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
        val httpClient = OkHttpClient()
    }

    // Duplicate messages rokne ke liye
    private var lastSentMessage = ""
    private var lastSentTime    = 0L
    private val COOLDOWN_MS     = 30000L
    private var lastSentUrl = ""
    private var lastUrlTime = 0L
    private val URL_COOLDOWN_MS = 10000L

    // child_id same key as ForegroundServices
    private val childId: Int
    get() {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return (prefs.getLong("flutter.child_id", -1L)).toInt()  
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
            packageName.contains("messaging")  -> "SMS"
            packageName.contains("mms")        -> "SMS"
            packageName.contains("snapchat")  -> "Snapchat"
            
            
            else -> null
        }

        // Content apps map
            val contentAppName = when {
                packageName.contains("youtube") -> "YouTube"
                packageName.contains("tiktok") || packageName.contains("musical") -> "TikTok"
                packageName.contains("instagram") -> "Instagram"
                packageName.contains("snapchat") -> "Snapchat"
                else -> null
            }

            if (contentAppName != null ) {
    val source = event.source ?: return
    val contentTexts = extractContentText(source, contentAppName)
    contentTexts.forEach { text ->
        val now = System.currentTimeMillis()
        if (text != lastSentMessage || now - lastSentTime > COOLDOWN_MS) {
            lastSentMessage = text
            lastSentTime = now
            Log.d("ContentMonitor", "App: $contentAppName | Text: $text")
            sendContentToBackend(appName = contentAppName, content = text)
        }
    }
}

if (chatAppName != null) {
    val source = event.source ?: return
    val messages = extractChatMessages(source)
    
    messages.forEach { msg ->
        val now = System.currentTimeMillis()
        if (msg != lastSentMessage || now - lastSentTime > COOLDOWN_MS) {
            lastSentMessage = msg
            lastSentTime = now
            Log.d("ChatMonitor", "App: $chatAppName | Msg: $msg")
            sendChatToBackend(appName = chatAppName, message = msg, node = source)
        }
    }
}
   
if (contentAppName != null) {
    // Instagram ke liye sirf feed/scroll events pe content bhejo
    val isFeedEvent = event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED ||
                      event.eventType == AccessibilityEvent.TYPE_VIEW_SCROLLED
    
    // YouTube, TikTok — har event pe content bhejo
    // Instagram — sirf feed events pe
    val shouldMonitorContent = when (contentAppName) {
        "Instagram" -> isFeedEvent
        else -> true
    }
    
    if (shouldMonitorContent) {
        val source = event.source ?: return
        val contentTexts = extractContentText(source, contentAppName)
        contentTexts.forEach { text ->
            val now = System.currentTimeMillis()
            if (text != lastSentMessage || now - lastSentTime > COOLDOWN_MS) {
                lastSentMessage = text
                lastSentTime = now
                Log.d("ContentMonitor", "App: $contentAppName | Text: $text")
                sendContentToBackend(appName = contentAppName, content = text)
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
            "type a message...", "aa", "bb","type message", "new message", "send", "mms", "sms"
        )
        return labels.contains(text.lowercase())
    }

    private fun isTimestamp(text: String): Boolean {
        return text.matches(Regex("\\d{1,2}:\\d{2}(\\s?[APap][Mm])?"))
    }

// sender ko extract kre ga chat se

    private fun extractSender(node: AccessibilityNodeInfo?, appName: String): String {
    if (node == null) return "unknown"

    return when (appName) {
        "WhatsApp" -> extractWhatsAppSender(node)
        "Telegram" -> extractTelegramSender(node)
        "Instagram" -> extractInstagramSender(node)
        "SMS" -> extractSmsSender(node)
        else -> extractGenericSender(node)
    }
}

// WhatsApp — contact name top bar mein hota hai
private fun extractWhatsAppSender(node: AccessibilityNodeInfo): String {
    // Action bar mein contact name dhundo
    val actionBarIds = listOf(
        "com.whatsapp:id/conversation_contact_name",
        "com.whatsapp:id/contact_name",
        "com.whatsapp:id/name"
    )
    for (id in actionBarIds) {
        val nodes = node.findAccessibilityNodeInfosByViewId(id)
        if (!nodes.isNullOrEmpty()) {
            val text = nodes[0].text?.toString()?.trim()
            if (!text.isNullOrBlank() && text.length > 1) {
                Log.d("SenderDetect", "WhatsApp sender: $text")
                return text
            }
        }
    }
    return extractGenericSender(node)
}

// Telegram — channel/contact name
private fun extractTelegramSender(node: AccessibilityNodeInfo): String {
    val ids = listOf(
        "org.telegram.messenger:id/name_text",
        "org.telegram.messenger:id/title",
        "org.telegram.messenger:id/chat_name"
    )
    for (id in ids) {
        val nodes = node.findAccessibilityNodeInfosByViewId(id)
        if (!nodes.isNullOrEmpty()) {
            val text = nodes[0].text?.toString()?.trim()
            if (!text.isNullOrBlank() && text.length > 1) {
                Log.d("SenderDetect", "Telegram sender: $text")
                return text
            }
        }
    }
    return extractGenericSender(node)
}

// Instagram — username top pe hota hai
private fun extractInstagramSender(node: AccessibilityNodeInfo): String {
    val ids = listOf(
        "com.instagram.android:id/thread_title_username",
        "com.instagram.android:id/row_header_textview",
        "com.instagram.android:id/title"
    )
    for (id in ids) {
        val nodes = node.findAccessibilityNodeInfosByViewId(id)
        if (!nodes.isNullOrEmpty()) {
            val text = nodes[0].text?.toString()?.trim()
            if (!text.isNullOrBlank() && text.length > 1) {
                Log.d("SenderDetect", "Instagram sender: $text")
                return text
            }
        }
    }
    return extractGenericSender(node)
}

// SMS — phone number ya contact name
private fun extractSmsSender(node: AccessibilityNodeInfo): String {
    val ids = listOf(
        "com.samsung.android.messaging:id/contact_name",
        "com.android.mms:id/contact_name",
        "com.google.android.apps.messaging:id/conversation_title"
    )
    for (id in ids) {
        val nodes = node.findAccessibilityNodeInfosByViewId(id)
        if (!nodes.isNullOrEmpty()) {
            val text = nodes[0].text?.toString()?.trim()
            if (!text.isNullOrBlank() && text.length > 1) {
                Log.d("SenderDetect", "SMS sender: $text")
                return text
            }
        }
    }
    return extractGenericSender(node)
}

// Generic fallback — pehle text node jo naam jaisa lage
private fun extractGenericSender(node: AccessibilityNodeInfo): String {
    return findSenderRecursive(node, 0) ?: "unknown"
}

private fun findSenderRecursive(node: AccessibilityNodeInfo?, depth: Int): String? {
    if (node == null || depth > 5) return null

    val text = node.text?.toString()?.trim()
    if (!text.isNullOrBlank()
        && text.length in 2..40
        && !isUiLabel(text)
        && !isTimestamp(text)
        && !isUrl(text)
        && !text.matches(Regex("\\d+"))  // sirf numbers nahi
    ) {
        return text
    }

    for (i in 0 until node.childCount) {
        val result = findSenderRecursive(node.getChild(i), depth + 1)
        if (result != null) return result
    }
    return null
}

    // Sending Chat to Backend
    private fun sendChatToBackend(appName: String, message: String, node: AccessibilityNodeInfo? = null) {
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
                    put("sender", extractSender(node,appName))
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

                httpClient.newCall(request).execute().use { response ->
                Log.d("ChatMonitor", "Sent | Response: ${response.code}")
            } 
                

            } catch (e: Exception) {
                Log.e("ChatMonitor", "Send failed: ${e.message}")
            } //response.close() 
        }
    }

    // apps ka content extract krne k lye

    private fun extractContentText(node: AccessibilityNodeInfo, appName: String): List<String> {
    val result = mutableListOf<String>()
    
    // App-specific IDs se title fetch karo
    val titleIds = when (appName) {
        "YouTube" -> listOf(
            "com.google.android.youtube:id/title",
            "com.google.android.youtube:id/video_title",
            "com.google.android.youtube:id/text"
        )
        "TikTok" -> listOf(
            "com.zhiliaoapp.musically:id/desc",
            "com.ss.android.ugc.trill:id/text_desc"
        )
        else -> listOf()
    }
    
    for (id in titleIds) {
        val nodes = node.findAccessibilityNodeInfosByViewId(id)
        nodes?.forEach { n ->
            val text = n.text?.toString()?.trim()
            if (!text.isNullOrBlank() && text.length > 5) {
                result.add(text)
            }
        }
    }
    
    // Fallback — recursive text extraction
    if (result.isEmpty()) {
        extractTextRecursive(node, result, 0)
    }
    
    return result.distinct()
}

private fun sendContentToBackend(appName: String, content: String) {
    val id = childId
    if (id == -1) return

    CoroutineScope(Dispatchers.IO).launch {
        try {
            val json = JSONObject().apply {
                put("child_id", id)
                put("app_name", appName)
                put("sender", "content")  // content monitoring
                put("message", content)
                put("timestamp", SimpleDateFormat(
                    "yyyy-MM-dd'T'HH:mm:ss",
                    Locale.getDefault()
                ).format(Date()))
            }

            val body = json.toString().toRequestBody("application/json".toMediaType())
            val request = Request.Builder()
                .url("http://192.168.18.163:8000/collectchat/")
                .post(body)
                .build()

            httpClient.newCall(request).execute().use { response ->
                Log.d("ContentMonitor", "Sent | ${response.code}")
            }
        } catch (e: Exception) {
            Log.e("ContentMonitor", "Failed: ${e.message}")
        }
    }
}

    // Web Monitoring Code 
    private fun sendUrl(url: String) {
    val now = System.currentTimeMillis()
    
    // www. normalize karo comparison ke liye
    val normalizedUrl = url.trim()
        .removePrefix("https://")
        .removePrefix("http://")
        .removePrefix("www.")
        .trimEnd('/')

    val normalizedLast = lastSentUrl
        .removePrefix("https://")
        .removePrefix("http://")
        .removePrefix("www.")
        .trimEnd('/')

    // Duplicate check normalized URL pe
    if (normalizedUrl == normalizedLast && now - lastUrlTime < URL_COOLDOWN_MS) {
        Log.d("MyAccessibilityService", "Duplicate URL skip: $url")
        return
    }

    lastSentUrl = url.trim()
    lastUrlTime = now

    channel?.invokeMethod("onUrlDetected", "UI:$url")
    sendUrlToBackend(url)
}

    private fun isUrl(text: String): Boolean {
    val t = text.trim()
    // Sirf proper URLs accept karo
    if (t.startsWith("http://") || t.startsWith("https://")) return true
    if (t.startsWith("www.") && t.length > 8) return true
    
    // "Verifying...", "Loading..." jaise text reject karo
    if (t.contains(" ")) return false
    if (t.contains("...")) return false
    if (t.length < 6) return false
    
    // Must have valid TLD pattern (e.g. .com, .pk, .ag)
    val domainRegex = Regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}(/.*)?$")
    return domainRegex.matches(t)
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
    private fun sendUrlToBackend(rawUrl: String) {
    var cleanUrl = rawUrl.trim()
    if (!cleanUrl.startsWith("http://") && !cleanUrl.startsWith("https://")) {
        cleanUrl = "https://$cleanUrl"
    }
    
    val id = childId
    if (id == -1) {
        Log.e("MyAccessibilityService", "child_id not set — skipping URL")
        return
    }

    CoroutineScope(Dispatchers.IO).launch {
        try {
            val sdf = java.text.SimpleDateFormat(
                "yyyy-MM-dd'T'HH:mm:ss", 
                java.util.Locale.getDefault()
            )
            
            val json = JSONObject().apply {
                put("child_id", id)
                put("url", cleanUrl)
                put("usage_time", 0)
                put("timestamp", sdf.format(java.util.Date()))
            }

            val body = json.toString()
                .toRequestBody("application/json".toMediaType())

            val request = Request.Builder()
                .url("http://192.168.18.163:8000/collectwebusage/")
                .post(body)
                .build()

            httpClient.newCall(request).execute().use { response ->
                Log.d("MyAccessibilityService", "URL sent | ${response.code}")
            }
        } catch (e: Exception) {
            Log.e("MyAccessibilityService", "URL send failed: ${e.message}")
        }
    }
}

    override fun onInterrupt() {}
}