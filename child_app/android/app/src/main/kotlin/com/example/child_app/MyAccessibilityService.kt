package com.example.child_app

import android.accessibilityservice.AccessibilityService
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
import android.content.Context

class MyAccessibilityService : AccessibilityService() {

    companion object {
        var channel: MethodChannel? = null
    }

    // To avoid duplicate msgs
    private var lastSentMessage = ""
    private var lastSentTime    = 0L
    private val COOLDOWN_MS     = 4000L  // 4 sec mein same message dobara nahi

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        val packageName = event.packageName?.toString() ?: return

        //  Web Monitoring 
        val isBrowser = packageName.contains("chrome") ||
                packageName.contains("browser") ||
                packageName.contains("sbrowser") ||
                packageName.contains("firefox") ||
                packageName.contains("opera")

        if (isBrowser) {
            val eventText = event.text?.joinToString(" ") ?: ""
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

                    // Duplicate check
                    if (message != lastSentMessage || now - lastSentTime > COOLDOWN_MS) {
                        lastSentMessage = message
                        lastSentTime    = now

                        // Backend pe bhejo
                        sendChatToBackend(
                            appName = chatAppName,
                            message = message,
                        )

                        // Flutter ko bhi bhejo (agar UI update chahiye)
                        channel?.invokeMethod("onChatText", message)
                    }
                }
            }
        }
    }

    // Extracting chat msgs from screen
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
            // Timestamp aur UI labels filter karo
            if (!isTimestamp(text) && !isUiLabel(text)) {
                result.add(text)
            }
        }

        for (i in 0 until node.childCount) {
            extractTextRecursive(node.getChild(i), result, depth + 1)
        }
    }

    // Common UI labels -- jo capture nahi karni screen se
    private fun isUiLabel(text: String): Boolean {
        val labels = setOf(
            "type a message", "message", "search", "reply",
            "forward", "delete", "copy", "share", "online",
            "yesterday", "today", "delivered", "read", "sent"
        )
        return labels.contains(text.lowercase())
    }

    // Timestamp check (e.g. "10:30 AM", "12:45")
    private fun isTimestamp(text: String): Boolean {
        return text.matches(Regex("\\d{1,2}:\\d{2}(\\s?[APap][Mm])?"))
    }

    // Sending collected messages to backend
    private fun sendChatToBackend(appName: String, message: String) {
        val prefs   = getSharedPreferences("watcher_prefs", Context.MODE_PRIVATE)
        val childId = prefs.getInt("child_id", -1)
        if (childId == -1) return

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val json = JSONObject().apply {
                    put("child_id",  childId)
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
                    .url("http://192.168.18.163:8000/collectchat/")
                    .post(body)
                    .build()

                val response = client.newCall(request).execute()
                Log.d("ChatMonitor", "Sent: $message | Response: ${response.code}")

            } catch (e: Exception) {
                Log.e("ChatMonitor", "Send failed: ${e.message}")
            }
        }
    }

    // Website MOnitoring Code
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