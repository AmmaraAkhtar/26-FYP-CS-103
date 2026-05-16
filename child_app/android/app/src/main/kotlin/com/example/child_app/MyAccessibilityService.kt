package com.example.child_app

import android.accessibilityservice.AccessibilityService
import android.util.Log
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
        Log.d("MyAccessibilityService", "EVENT: $packageName | type: ${event.eventType}")

        // Web monitoring
        val isBrowser = packageName.contains("chrome") ||
                packageName.contains("browser") ||
                packageName.contains("sbrowser") ||
                packageName.contains("firefox") ||
                packageName.contains("opera")

        if (isBrowser) {
            val eventText = event.text?.joinToString(" ") ?: ""
            Log.d("MyAccessibilityService", "EVENT TEXT: $eventText")

            if (isUrl(eventText)) {
                sendUrl(eventText.trim())
                return
            }

            val source = event.source
            if (source != null) {
                val url = findUrlInNode(source)
                if (url != null) {
                    sendUrl(url)
                }
            }
        }

        // Chat monitoring
        val isChat = packageName.contains("whatsapp") ||
                packageName.contains("messenger") ||
                packageName.contains("telegram")

        if (isChat) {
            val text = event.text?.toString() ?: ""
            if (text.isNotEmpty()) {
                channel?.invokeMethod("onChatText", text)
            }
        }
    }


    private fun sendUrl(url: String) {
        Log.d("MyAccessibilityService", "SENDING URL: $url")
        channel?.invokeMethod("onUrlDetected", "UI:$url")
    }

    private fun isUrl(text: String): Boolean {
        val t = text.trim()
        return t.startsWith("http://") ||
                t.startsWith("https://") ||
                t.startsWith("www.") ||
                (t.contains(".") && !t.contains(" ") && t.length > 4)
    }

    private fun findUrlInNode(node: AccessibilityNodeInfo): String? {
        val addressBarIds = listOf(
            "com.android.chrome:id/url_bar",
            "com.android.chrome:id/search_box_text",
            "com.sec.android.app.sbrowser:id/location_bar_edit_text"
        )

        for (id in addressBarIds) {
            val nodes = node.findAccessibilityNodeInfosByViewId(id)
            if (nodes != null && nodes.isNotEmpty()) {
                val text = nodes[0].text?.toString()
                Log.d("MyAccessibilityService", "ADDRESS BAR FOUND: $text")
                if (text != null && isUrl(text)) {
                    return text
                }
            }
        }

        return findUrlRecursive(node, 0)
    }

    private fun findUrlRecursive(node: AccessibilityNodeInfo, depth: Int): String? {
        if (depth > 5) return null

        val text = node.text?.toString()
        if (text != null && isUrl(text)) {
            return text
        }

        for (i in 0 until node.childCount) {
            val child = node.getChild(i) ?: continue
            val result = findUrlRecursive(child, depth + 1)
            if (result != null) return result
        }

        return null
    }

    override fun onInterrupt() {}
}