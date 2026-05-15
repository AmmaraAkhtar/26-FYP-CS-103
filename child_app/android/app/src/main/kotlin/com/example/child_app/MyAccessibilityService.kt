package com.example.child_app

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

                channel?.invokeMethod("onUrlDetected", "UI:$url")
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