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
}package com.example.child_app

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import io.flutter.plugin.common.MethodChannel

class MyAccessibilityService : AccessibilityService() {

    companion object {
        var channel: MethodChannel? = null
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {

        if (event == null) return

        val packageName = event.packageName?.toString() ?: return

       


// CHAT MONITORING

        if (
            packageName.contains("whatsapp") ||
            packageName.contains("messenger")
        ) {

            val text = event.text.toString()

            if (text.isNotEmpty()) {

                channel?.invokeMethod(
                    "onChatText",
                    text
                )
            }
        }

       
// WEB MONITORING
       
        if (
            packageName.contains("chrome") ||
            packageName.contains("browser")
        ) {

            val source = event.source ?: return

            val url = findUrl(source)

            if (url != null) {

                channel?.invokeMethod(
                    "onUrlDetected",
                    url
                )
            }
        }
    }

    override fun onInterrupt() {}

  
    // URL Finder

    private fun findUrl(node: AccessibilityNodeInfo): String? {

        // Current node text
        val text = node.text?.toString()

        if (text != null) {

            if (
                text.startsWith("http") ||
                text.contains(".com") ||
                text.contains(".org") ||
                text.contains(".pk")
            ) {
                return text
            }
        }

        // Search children recursively
        for (i in 0 until node.childCount) {

            val child = node.getChild(i)

            if (child != null) {

                val result = findUrl(child)

                if (result != null) {
                    return result
                }
            }
        }

        return null
    }
}