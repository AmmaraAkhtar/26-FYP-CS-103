package com.example.child_app

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

class AlertSenderService : Service() {

    private val client = OkHttpClient.Builder()
        .connectTimeout(10, TimeUnit.SECONDS)
        .writeTimeout(10, TimeUnit.SECONDS)
        .readTimeout(10, TimeUnit.SECONDS)
        .build()

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val event = intent?.getStringExtra("event") ?: "UNKNOWN"
        val message = intent?.getStringExtra("message") ?: ""

        val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val childId = try {
            prefs.getInt("flutter.child_id", -1)
        } catch (e: ClassCastException) {
            prefs.getLong("flutter.child_id", -1L).toInt()
        }

        Thread {
            sendAlert(childId, event, message, startId)
        }.start()

        return START_NOT_STICKY
    }

    private fun sendAlert(childId: Int, event: String, message: String, startId: Int) {
        if (childId == -1) {
            Log.e("AlertSender", "Child ID not found")
            stopSelf(startId)
            return
        }

        val json = JSONObject().apply {
            put("child_id", childId)
            put("alert_type", "Critical")
            put("message", message)
            put("event", event)
        }

        val body = json.toString()
            .toRequestBody("application/json; charset=utf-8".toMediaType())

        val request = Request.Builder()
            .url("https://the-watcher-backend.onrender.com/sendalert/")
            .post(body)
            .build()

        try {
            client.newCall(request).execute().use { response ->
                Log.d("AlertSender", "Alert sent: ${response.code}")
            }
        } catch (e: IOException) {
            Log.e("AlertSender", "Failed to send alert: ${e.message}")
        } finally {
            stopSelf(startId)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}