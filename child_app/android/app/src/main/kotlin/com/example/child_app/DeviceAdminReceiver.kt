package com.example.child_app

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class MyDeviceAdminReceiver : DeviceAdminReceiver() {

    override fun onEnabled(context: Context, intent: Intent) {
        Log.d("DeviceAdmin", "Device Admin Enabled")
    }

    override fun onDisabled(context: Context, intent: Intent) {
        Log.d("DeviceAdmin", "Device Admin Disabled")
    }

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        // Jab koi disable karne ki koshish kare to warning message show ho ga 
        return "Contact parent to disable this protection."
    }
}