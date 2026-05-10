package com.example.child_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.content.SharedPreferences

class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON"
        ) {
            Log.d("BOOT_RECEIVER", "Phone booted - starting monitor service")

            // SharedPreferences se child_id lo (Flutter ne save kiya tha)
            val prefs = context.getSharedPreferences(
                "FlutterSharedPreferences", 
                Context.MODE_PRIVATE
            )
            
            // Flutter shared_preferences "flutter." prefix lagate hain
            val childId = prefs.getInt("flutter.child_id", -1)

            Log.d("BOOT_RECEIVER", "Child ID from prefs: $childId")

            val serviceIntent = Intent(context, MyForegroundService::class.java)
            serviceIntent.putExtra("child_id", childId)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
        }
    }
}