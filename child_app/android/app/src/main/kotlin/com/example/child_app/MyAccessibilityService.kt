package com.example.child_app

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class MyAccessibilityService : AccessibilityService() {

    companion object {
        var channel: MethodChannel? = null
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {

        if (event == null) return

        val packageName = event.packageName?.toString() ?: return
        val text = event.text?.toString() ?: ""

        // ignore empty noise
        if (text.isBlank()) return


//  CHAT DETECTION

        if (
            packageName.contains("whatsapp") ||
            packageName.contains("messenger") ||
            packageName.contains("telegram")
        ) {
            channel?.invokeMethod(
                "onChatText",
                mapOf(
                    "package" to packageName,
                    "text" to text
                )
            )
        }

// WEB / URL DETECTION

        if (
            packageName.contains("chrome") ||
            packageName.contains("browser")
        ) {
            val url = extractUrl(text)

            if (url != null) {
                channel?.invokeMethod(
                    "onUrlDetected",
                    mapOf(
                        "package" to packageName,
                        "url" to url
                    )
                )
            }
        }

      
//  GENERAL APP ACTIVITY

        channel?.invokeMethod(
            "onAppEvent",
            mapOf(
                "package" to packageName,
                "text" to text
            )
        )
    }

    override fun onInterrupt() {}


// URL EXTRACTION
   
    private fun extractUrl(text: String): String? {

        val lower = text.lowercase()

        return if (
            lower.contains("http") ||
            lower.contains(".com") ||
            lower.contains(".pk") ||
            lower.contains(".org")
        ) {
            text
        } else {
            null
        }
    }
}