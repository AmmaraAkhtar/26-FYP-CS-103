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

    // ── Separate cooldown variables for chat and content ──
    private var lastSentChatMessage = ""
    private var lastSentChatTime    = 0L
    private var lastSentContentText = ""
    private var lastSentContentTime = 0L
    private val COOLDOWN_MS         = 30000L

    // ── URL dedup ──
    private var lastSentUrl  = ""
    private var lastUrlTime  = 0L
    private val URL_COOLDOWN_MS = 10000L

    // App name map
private val monitoredApps = mapOf(
    "com.instagram.android"     to "Instagram",
    "com.google.android.youtube" to "YouTube",
    "com.zhiliaoapp.musically"  to "TikTok",
    "com.whatsapp"              to "WhatsApp",
    "com.facebook.katana"       to "Facebook",
    "com.snapchat.android"      to "Snapchat",
    "com.twitter.android"       to "Twitter",
    "com.roblox.client"         to "Roblox",
    "com.pubg.imobile"          to "PUBG",
)

private var lastOpenedApp = ""
private var lastOpenedTime = 0L
private val APP_OPEN_COOLDOWN = 60_000L  // same app 1 min mein dobara trigger na ho

    private val childId: Int
        get() {
            val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            return prefs.getLong("flutter.child_id", -1L).toInt()
        }

    // ────────────────────────────────────────────────────────────
    //  MAIN EVENT HANDLER
    // ────────────────────────────────────────────────────────────
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return
        val packageName = event.packageName?.toString() ?: return

        Log.d("MyAccessibilityService", "EVENT: $packageName | type: ${event.eventType}")

        // ── App Open Detection ──
    // MyAccessibilityService.kt mein
if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
    val now = System.currentTimeMillis()
    
    // System apps skip karo
    val skipPackages = setOf(
        "com.android.systemui",
        "com.sec.android.app.launcher",
        "com.samsung.android.incallui",
        "com.android.settings",
        "com.example.child_app"  // khud apni app
    )
    
    if (packageName !in skipPackages && 
        (packageName != lastOpenedApp || now - lastOpenedTime > APP_OPEN_COOLDOWN)) {
        
        lastOpenedApp  = packageName
        lastOpenedTime = now
        
        Log.d("AppOpenMonitor", "App opened: $packageName")
        val appDisplayName = monitoredApps[packageName] ?: packageName
//sendAppOpenToBackend(packageName, appDisplayName)
    }
}

        // ── 1. Web / Browser monitoring ──
        val isBrowser = packageName.contains("chrome")   ||
                        packageName.contains("browser")  ||
                        packageName.contains("sbrowser") ||
                        packageName.contains("firefox")  ||
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
            return   // browser events ke baad chat/content mat check karo
        }

        // ── 2. Source node — ek baar fetch karo ──
        val source = event.source
        if (source == null) {
            Log.w("MyAccessibilityService", "source null for $packageName — skipping")
            return
        }

        // ── 3. App name maps ──
        val chatAppName = when {
            packageName.contains("whatsapp")  -> "WhatsApp"
            packageName.contains("messenger") -> "Messenger"
            packageName.contains("telegram")  -> "Telegram"
            packageName.contains("instagram") -> "Instagram"
            packageName.contains("messaging") -> "SMS"
            packageName.contains("mms")       -> "SMS"
            packageName.contains("snapchat")  -> "Snapchat"
            else -> null
        }

        val contentAppName = when {
            packageName.contains("youtube")                                   -> "YouTube"
            packageName.contains("tiktok") || packageName.contains("musical") -> "TikTok"
            packageName.contains("instagram")                                 -> "Instagram"
            packageName.contains("snapchat")                                  -> "Snapchat"
            else -> null
        }

        // ── 4. Chat monitoring ──
        if (chatAppName != null) {
            val messages = extractChatMessages(source)
            messages.forEach { msg ->
                val now = System.currentTimeMillis()
                if (msg != lastSentChatMessage || now - lastSentChatTime > COOLDOWN_MS) {
                    lastSentChatMessage = msg
                    lastSentChatTime    = now
                    Log.d("ChatMonitor", "App: $chatAppName | Msg: $msg")
                    sendChatToBackend(appName = chatAppName, message = msg, node = source)
                }
            }
        }

        // ── 5. Content monitoring (YouTube, TikTok, Instagram, Snapchat) ──
        if (contentAppName != null) {
            val isFeedEvent =
                event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED ||
                event.eventType == AccessibilityEvent.TYPE_VIEW_SCROLLED

            val shouldMonitor = when (contentAppName) {
                "Instagram" -> isFeedEvent   // Instagram pe sirf scroll/feed events
                else        -> true          // YouTube, TikTok — har event
            }

            if (shouldMonitor) {
                val contentTexts = extractContentText(source, contentAppName)
                contentTexts.forEach { text ->
                    val now = System.currentTimeMillis()
                    if (text != lastSentContentText || now - lastSentContentTime > COOLDOWN_MS) {
                        lastSentContentText = text
                        lastSentContentTime = now
                        Log.d("ContentMonitor", "App: $contentAppName | Text: $text")
                        sendContentToBackend(appName = contentAppName, content = text)
                    }
                }
            }
        }
    }

    private fun sendAppOpenToBackend(packageName: String, appName: String) {
    val id = childId
    if (id == -1) return

    CoroutineScope(Dispatchers.IO).launch {
        try {
            val sdf  = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
            val json = JSONObject().apply {
                put("child_id",    id)
                put("usage_data",  org.json.JSONArray().apply {
                    put(JSONObject().apply {
                        put("package_name", packageName)
                        put("usage_time",   0)  // agent khud calculate karega
                    })
                })
                put("timestamp", sdf.format(Date()))
            }

            val body    = json.toString().toRequestBody("application/json".toMediaType())
            val request = Request.Builder()
                .url("https://the-watcher-backend.onrender.com/appdata/")
                .post(body)
                .build()

            httpClient.newCall(request).execute().use { response ->
                Log.d("AppOpenMonitor", "$appName | Response: ${response.code}")
            }
        } catch (e: Exception) {
            Log.e("AppOpenMonitor", "Failed: ${e.message}")
        }
    }
}

    // ────────────────────────────────────────────────────────────
    //  CHAT EXTRACTION
    // ────────────────────────────────────────────────────────────
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
            "type a message...", "aa", "bb", "type message",
            "new message", "send", "mms", "sms"
        )
        return labels.contains(text.lowercase())
    }

    private fun isTimestamp(text: String): Boolean {
        return text.matches(Regex("\\d{1,2}:\\d{2}(\\s?[APap][Mm])?"))
    }

    // ────────────────────────────────────────────────────────────
    //  SENDER EXTRACTION
    // ────────────────────────────────────────────────────────────
    private fun extractSender(node: AccessibilityNodeInfo?, appName: String): String {
        if (node == null) return "unknown"
        return when (appName) {
            "WhatsApp"  -> extractWhatsAppSender(node)
            "Telegram"  -> extractTelegramSender(node)
            "Instagram" -> extractInstagramSender(node)
            "SMS"       -> extractSmsSender(node)
            else        -> extractGenericSender(node)
        }
    }

    private fun extractWhatsAppSender(node: AccessibilityNodeInfo): String {
        val ids = listOf(
            "com.whatsapp:id/conversation_contact_name",
            "com.whatsapp:id/contact_name",
            "com.whatsapp:id/name"
        )
        for (id in ids) {
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
            && !text.matches(Regex("\\d+"))
        ) {
            return text
        }

        for (i in 0 until node.childCount) {
            val result = findSenderRecursive(node.getChild(i), depth + 1)
            if (result != null) return result
        }
        return null
    }

    // ────────────────────────────────────────────────────────────
    //  SEND CHAT TO BACKEND
    // ────────────────────────────────────────────────────────────
    private fun sendChatToBackend(
        appName: String,
        message: String,
        node: AccessibilityNodeInfo? = null
    ) {
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
                    put("sender",    extractSender(node, appName))
                    put("message",   message)
                    put("timestamp", SimpleDateFormat(
                        "yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()
                    ).format(Date()))
                }

                val body    = json.toString().toRequestBody("application/json".toMediaType())
                val request = Request.Builder()
                    .url("https://the-watcher-backend.onrender.com/collectchat/")
                    .post(body)
                    .build()

                httpClient.newCall(request).execute().use { response ->
                    Log.d("ChatMonitor", "Sent | Response: ${response.code}")
                }
            } catch (e: Exception) {
                Log.e("ChatMonitor", "Send failed: ${e.message}")
            }
        }
    }

    // ────────────────────────────────────────────────────────────
    //  CONTENT EXTRACTION (YouTube, TikTok, etc.)
    // ────────────────────────────────────────────────────────────
    private fun extractContentText(
        node: AccessibilityNodeInfo,
        appName: String
    ): List<String> {
        val result = mutableListOf<String>()

        val titleIds = when (appName) {
            "YouTube" -> listOf(
                "com.google.android.youtube:id/title",
                "com.google.android.youtube:id/video_title",
                "com.google.android.youtube:id/text"
            )
            "TikTok"  -> listOf(
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

        // Fallback — recursive extraction
        if (result.isEmpty()) {
            extractTextRecursive(node, result, 0)
        }

        return result.distinct()
    }

    // ────────────────────────────────────────────────────────────
    //  SEND CONTENT TO BACKEND
    // ────────────────────────────────────────────────────────────
    private fun sendContentToBackend(appName: String, content: String) {
        val id = childId
        if (id == -1) {
            Log.e("ContentMonitor", "child_id not set — skipping")
            return
        }

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val json = JSONObject().apply {
                    put("child_id",  id)
                    put("app_name",  appName)
                    put("sender",    "content")
                    put("message",   content)
                    put("timestamp", SimpleDateFormat(
                        "yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()
                    ).format(Date()))
                }

                val body    = json.toString().toRequestBody("application/json".toMediaType())
                val request = Request.Builder()
                    .url("https://the-watcher-backend.onrender.com/collectchat/")
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

    // ────────────────────────────────────────────────────────────
    //  WEB / URL MONITORING
    // ────────────────────────────────────────────────────────────
    private fun sendUrl(url: String) {
        val now = System.currentTimeMillis()

        val normalizedUrl = url.trim()
            .removePrefix("https://").removePrefix("http://")
            .removePrefix("www.").trimEnd('/')

        val normalizedLast = lastSentUrl
            .removePrefix("https://").removePrefix("http://")
            .removePrefix("www.").trimEnd('/')

        if (normalizedUrl == normalizedLast && now - lastUrlTime < URL_COOLDOWN_MS) {
            Log.d("MyAccessibilityService", "Duplicate URL skip: $url")
            return
        }

        lastSentUrl  = url.trim()
        lastUrlTime  = now

        channel?.invokeMethod("onUrlDetected", "UI:$url")
        sendUrlToBackend(url)
    }

    private fun isUrl(text: String): Boolean {
        val t = text.trim()
        if (t.startsWith("http://") || t.startsWith("https://")) return true
        if (t.startsWith("www.") && t.length > 8) return true
        if (t.contains(" ") || t.contains("...") || t.length < 6) return false
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
            if (!nodes.isNullOrEmpty()) {
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
                val sdf  = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
                val json = JSONObject().apply {
                    put("child_id",   id)
                    put("url",        cleanUrl)
                    put("usage_time", 0)
                    put("timestamp",  sdf.format(Date()))
                }

                val body    = json.toString().toRequestBody("application/json".toMediaType())
                val request = Request.Builder()
                    .url("https://the-watcher-backend.onrender.com/collectwebusage/")
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
    override fun onUnbind(intent: android.content.Intent?): Boolean {
    Log.d("AccessibilityService", "Accessibility disabled — reporting to backend")
    reportDeviceStatus("accessibility_off")
    return super.onUnbind(intent)
}

private fun reportDeviceStatus(statusType: String) {
    val id = childId
    if (id == -1) return

    CoroutineScope(Dispatchers.IO).launch {
        try {
            val json = JSONObject().apply {
                put("child_id", id)
                put("status_type", statusType)
            }
            val body = json.toString()
                .toRequestBody("application/json".toMediaType())
            val request = Request.Builder()
                .url("https://the-watcher-backend.onrender.com/report-device-status/")
                .post(body)
                .build()
            httpClient.newCall(request).execute().close()
            Log.d("AccessibilityService", "Status reported: $statusType")
        } catch (e: Exception) {
            Log.e("AccessibilityService", "Report failed: ${e.message}")
        }
    }
}

    // ────────────────────────────────────────────────────────────
    override fun onInterrupt() {}
}