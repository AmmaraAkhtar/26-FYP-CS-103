package com.example.child_app

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MyAccessibilityService : AccessibilityService() {

    companion object {
        var channel: MethodChannel? = null
    }

    // Duplicate messages rokne ke liye
    private var lastSentMessage = ""
    private var lastSentTime    = 0L
    private val COOLDOWN_MS     = 4000L

    // child_id same key as ForegroundServices
    private val childId: Int
        get() {
            val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            return prefs.getInt("flutter.child_id", -1)
        }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return
        val packageName = event.packageName?.toString() ?: return

        Log.d("MyAccessibilityService", "EVENT: $packageName | type: ${event.eventType}")

        // Web Monitoring
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
                if (url != null) sendUrl(url)
            }
        }

        // Chat Monitoring 
        val chatAppName = when {
            packageName.contains("whatsapp")  -> "WhatsApp"
            packageName.contains("messenger") -> "Messenger"
            packageName.contains("telegram")  -> "Telegram"
            packageName.contains("instagram") -> "Instagram"
            packageName.contains("snapchat")  -> "Snapchat"
            else -> null
        }

        if (chatAppName != null) {
            val source = event.source ?: return
            val messages = extractChatMessages(source)

            messages.forEach { message ->
                if (message.isNotBlank() && message.length > 3) {
                    val now = System.currentTimeMillis()

                    if (message != lastSentMessage || now - lastSentTime > COOLDOWN_MS) {
                        lastSentMessage = message
                        lastSentTime    = now

                        Log.d("ChatMonitor", "App: $chatAppName | Msg: $message")

                        // Sending  to backend
                        sendChatToBackend(appName = chatAppName, message = message)

                        // Sending chats to flutter
                        channel?.invokeMethod("onChatText", message)
                    }
                }
            }
        }
    }

    // Extract Messages from Screen
    private fun extractChatMessages(node: AccessibilityNodeInfo): List<String> {
        val result = mutableListOf<String>()
        extractTextRecursive(node, result, depth = 0)
        return result
    }

    private fun extractTextRecursive(
        node: AccessibilityNodeInfo?,
        result: MutableList<String>,
        depth: Int
    ) {
        if (node == null || depth > 8) return

        val text = node.text?.toString()?.trim()
        if (!text.isNullOrBlank() && text.length > 3 && !isUrl(text)) {
            if (!isTimestamp(text) && !isUiLabel(text)) {
                result.add(text)
            }
        }

        for (i in 0 until node.childCount) {
            extractTextRecursive(node.getChild(i), result, depth + 1)
        }
    }

    private fun isUiLabel(text: String): Boolean {
        val labels = setOf(
            "type a message", "message", "search", "reply",
            "forward", "delete", "copy", "share", "online",
            "yesterday", "today", "delivered", "read", "sent",
            "type a message...", "aa", "bb"
        )
        return labels.contains(text.lowercase())
    }

    private fun isTimestamp(text: String): Boolean {
        return text.matches(Regex("\\d{1,2}:\\d{2}(\\s?[APap][Mm])?"))
    }

    // Sending Chat to Backend
    private fun sendChatToBackend(appName: String, message: String) {
        val id = childId
        if (id == -1) {
            Log.e("ChatMonitor", "child_id not set — skipping")
            return
        }

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val json = JSONObject().apply {
                    put("child_id",  id)
                    put("app_name",  appName)
                    put("sender",    "unknown")
                    put("message",   message)
                    put("timestamp", SimpleDateFormat(
                        "yyyy-MM-dd'T'HH:mm:ss",
                        Locale.getDefault()
                    ).format(Date()))
                }

                val client = OkHttpClient()
                val body   = json.toString()
                    .toRequestBody("application/json".toMediaType())

                val request = Request.Builder()
                    .url("http://192.168.18.166:8000/collectchat/")
                    .post(body)
                    .build()

                val response = client.newCall(request).execute()
                Log.d("ChatMonitor", "Sent  | Response: ${response.code}")

            } catch (e: Exception) {
                Log.e("ChatMonitor", "Send failed: ${e.message}")
            }
        }
    }

    // Web Monitoring Code 
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
                if (text != null && isUrl(text)) return text
            }
        }
        return findUrlRecursive(node, 0)
    }

    private fun findUrlRecursive(node: AccessibilityNodeInfo, depth: Int): String? {
        if (depth > 5) return null
        val text = node.text?.toString()
        if (text != null && isUrl(text)) return text
        for (i in 0 until node.childCount) {
            val child  = node.getChild(i) ?: continue
            val result = findUrlRecursive(child, depth + 1)
            if (result != null) return result
        }
        return null
    }

    override fun onInterrupt() {}
}