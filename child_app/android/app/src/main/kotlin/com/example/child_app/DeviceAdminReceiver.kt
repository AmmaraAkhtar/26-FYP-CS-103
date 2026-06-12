package com.example.child_app

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class MyDeviceAdminReceiver : DeviceAdminReceiver() {

    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Log.d("DeviceAdmin", "Device Admin Enabled")
    }

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        Log.d("DeviceAdmin", "Disable Requested - sending alert 1")

        val serviceIntent = Intent(context, AlertSenderService::class.java)
        serviceIntent.putExtra("event", "DISABLE_REQUESTED")
        serviceIntent.putExtra("message", "Child ne app ko deactivate karne ki koshish ki hai!")
        context.startService(serviceIntent)

        return "Yeh app aapke parent ki permission ke bina disable nahi honi chahiye. Parent ko notify kar diya gaya hai."
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Log.d("DeviceAdmin", "Disabled - sending alert 2 (CRITICAL)")

        val serviceIntent = Intent(context, AlertSenderService::class.java)
        serviceIntent.putExtra("event", "ADMIN_DISABLED")
        serviceIntent.putExtra("message", "ALERT: Monitoring app disable ho gayi hai. App jald hi uninstall ho sakti hai!")
        context.startService(serviceIntent)
    }
}