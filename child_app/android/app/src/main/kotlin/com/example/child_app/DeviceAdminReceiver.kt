package com.example.child_app

import android.app.admin.DeviceAdminReceiver
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import okhttp3.*
import org.json.JSONObject
import java.io.IOException
import android.content.SharedPreferences

class MyDeviceAdminReceiver : DeviceAdminReceiver() {

    private val client = OkHttpClient()
    private val BASE_URL = "http://192.168.18.163:8000"

    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Log.d("DeviceAdmin", "Device Admin Enabled")
    }

    // Sending Alert to parent when child try to uninstall the app
    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        Log.d("DeviceAdmin", "Disable Requested - sending alert 1")
        sendAlertToBackend(context, "DISABLE_REQUESTED",
            "Child ne app ko deactivate karne ki koshish ki hai!")
        return "Yeh app aapke parent ki permission ke bina disable nahi honi chahiye. Parent ko notify kar diya gaya hai."
    }

    // Alert on disabling child app (stage before uninstall!!!!!!!!!)
    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Log.d("DeviceAdmin", "Disabled - sending alert 2 (CRITICAL)")
        sendAlertToBackend(context, "ADMIN_DISABLED",
            "ALERT: Monitoring app disable ho gayi hai. App jald hi uninstall ho sakti hai!")
    }

    // call to backend
    private fun sendAlertToBackend(context: Context, alertType: String, message: String) {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val childId = prefs.getInt("flutter.child_id", -1)

        if (childId == -1) {
            Log.e("DeviceAdmin", "Child ID not found")
            return
        }

        val json = JSONObject().apply {
            put("child_id", childId)
            put("alert_type", "Critical")
            put("message", message)
            put("event", alertType)
        }

        val body = RequestBody.create(
            MediaType.parse("application/json; charset=utf-8"), json.toString()
        )

        val request = Request.Builder()
            .url("$BASE_URL/sendalert/")
            .post(body)
            .build()

        // Synchronous call - kyunki receiver thoda hi time deta hai async ko
        try {
            client.newCall(request).execute().use { response ->
                Log.d("DeviceAdmin", "Alert sent: ${response.code()}")
            }
        } catch (e: IOException) {
            Log.e("DeviceAdmin", "Failed to send alert: ${e.message}")
        }
    }
}