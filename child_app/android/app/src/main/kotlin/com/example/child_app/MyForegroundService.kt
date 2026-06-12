package com.example.child_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.provider.Settings
import androidx.core.app.NotificationCompat

import okhttp3.Call
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody

import org.json.JSONArray
import org.json.JSONObject

import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*

class MyForegroundService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var childId: Int = -1
    private var isMonitoring = false
    private var lastSmsTimestamp: Long = 0L 
    private val httpClient = OkHttpClient.Builder().connectTimeout(30, java.util.concurrent.TimeUnit.SECONDS).readTimeout(30, java.util.concurrent.TimeUnit.SECONDS).build()

    // Service create hoti hai
    override fun onCreate() {
        super.onCreate()

        createNotificationChannel()

        val notification: Notification =
            NotificationCompat.Builder(this, "monitor_channel")
                .setContentTitle("Child Monitoring Active")
                .setContentText("Monitoring apps in background")
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setOngoing(true) //  User dismiss nahi kar sakta
                .build()

        startForeground(1, notification)

        Log.d("MONITOR_SERVICE", "Service Created")
    }

    private fun checkDeactivateCommand(childId: Int) {
    Thread {
        try {
            val url = "https://yourbackend.com/api/check-command/?child_id=$childId"
            val connection = java.net.URL(url).openConnection() as java.net.HttpURLConnection
            connection.requestMethod = "GET"
            
            val response = connection.inputStream.bufferedReader().readText()
            val json = org.json.JSONObject(response)
            
            if (json.getBoolean("deactivate")) {
                // Device Admin deactivate karo
                deactivateDeviceAdmin()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }.start()
}
 // deactivate admin function 
        private fun deactivateDeviceAdmin() {
            val deviceAdminComponent = android.content.ComponentName(
                this,
                MyDeviceAdminReceiver::class.java
            )
            val dpm = getSystemService(android.content.Context.DEVICE_POLICY_SERVICE)
                    as android.app.admin.DevicePolicyManager
            
            if (dpm.isAdminActive(deviceAdminComponent)) {
                dpm.removeActiveAdmin(deviceAdminComponent)
            }
        }

    // childId lo phir monitoring shuru karo
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        // Intent se child_id lo
        val intentChildId = intent?.getIntExtra("child_id", -1) ?: -1

        // Agar intent mein nahi mila to SharedPreferences se lo
        if (intentChildId != -1) {
            childId = intentChildId
        } else {
            val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
            childId = prefs.getInt("flutter.child_id", -1)
        }

        Log.d("MONITOR_SERVICE", "Child ID set: $childId")

        // Sirf ek baar monitoring shuru karo
        if (!isMonitoring) {
            isMonitoring = true
            startMonitoring()
        }

        return START_STICKY //  System kill kare to restart ho
    }

    //  App swipe karke band ho to service restart karo
    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d("MONITOR_SERVICE", " App removed - Restarting service...")

        val restartIntent = Intent(applicationContext, MyForegroundService::class.java)
        restartIntent.putExtra("child_id", childId)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(restartIntent)
        } else {
            startService(restartIntent)
        }

        super.onTaskRemoved(rootIntent)
    }
// Function to check whether accessibility service enabled or not
    private fun isAccessibilityServiceEnabled(): Boolean {
    val enabledServices = Settings.Secure.getString(
        contentResolver,
        Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
    )
    return enabledServices?.contains(packageName) == true
}

private fun checkAccessibilityStatus() {
    if (!isAccessibilityServiceEnabled()) {
        Log.w("MONITOR_SERVICE", "Accessibility service is DISABLED!")
        sendAccessibilityAlert()
    }
}

private fun sendAccessibilityAlert() {
    if (childId == -1) return

    val json = JSONObject().apply {
        put("child_id", childId)
        put("alert_type", "High")
        put("message", "Chat/Web monitoring disabled - Accessibility permission off")
    }

    val body = json.toString()
        .toRequestBody("application/json".toMediaType())

    val request = Request.Builder()
        .url("http://192.168.18.163:8000/sendalert/")
        .post(body)
        .build()

    httpClient.newCall(request).enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
            Log.e("MONITOR_SERVICE", "Accessibility alert failed: ${e.message}")
        }
        override fun onResponse(call: Call, response: Response) {
            Log.d("MONITOR_SERVICE", "Accessibility alert sent | ${response.code}")
        }
    })
}

    //  Heartbeat — backend ko batata hai ke device/app abhi tak active hai
    private fun sendHeartbeat() {
        if (childId == -1) {
            Log.e("MONITOR_SERVICE", "Heartbeat: child_id not set — skipping")
            return
        }

        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        sdf.timeZone = TimeZone.getTimeZone("UTC")

        val json = JSONObject().apply {
            put("child_id", childId)
            put("timestamp", sdf.format(Date()))
        }

        val body = json.toString()
            .toRequestBody("application/json".toMediaType())

        val request = Request.Builder()
            .url("http://192.168.18.163:8000/heartbeat/")
            .post(body)
            .build()

        httpClient.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("MONITOR_SERVICE", "Heartbeat failed: ${e.message}")
            }
            override fun onResponse(call: Call, response: Response) {
                Log.d("MONITOR_SERVICE", "Heartbeat sent | ${response.code}")
                response.close()
            }
        })
    }

    //  Monitoring loop
    private fun startMonitoring() {
        handler.removeCallbacksAndMessages(null) // Purani loop band karo

        handler.post(object : Runnable {
            override fun run() {
                Log.d("MONITOR_SERVICE", "Tick - Child ID: $childId")
                fetchAndSendData()
                collectAndSendSms() 
                sendHeartbeat()
                 checkAccessibilityStatus() 
                handler.postDelayed(this, 300000) // Har 10 second baad
            }
        })
    }

    //  Usage data fetch karo
    private fun fetchAndSendData() {
        try {
            val endTime = System.currentTimeMillis()
            val startTime = endTime - (1000 * 60) // Last 1 minute

            val usageStatsManager =
                getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

            val stats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                startTime,
                endTime
            )

            if (stats.isNullOrEmpty()) {
                Log.d("MONITOR_SERVICE", " No usage stats - Permission check karo")
                return
            }

            val appsArray = JSONArray()

            for (app in stats) {
                if (app.totalTimeInForeground > 0) {
                    val obj = JSONObject()
                    obj.put("package_name", app.packageName)
                    obj.put("usage_time", app.totalTimeInForeground / 1000)
                    appsArray.put(obj)
                }
            }

            Log.d("MONITOR_SERVICE", " Apps found: ${appsArray.length()}")

            if (appsArray.length() > 0) {
                sendToBackend(appsArray)
            }

        } catch (e: Exception) {
            Log.e("MONITOR_SERVICE", " Error fetching data: ${e.message}")
        }
    }

    //  Backend ko data bhejo
    private fun sendToBackend(apps: JSONArray) {

        if (childId == -1) {
            Log.e("MONITOR_SERVICE", " Child ID not set - skipping")
            return
        }

        val client = httpClient

        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        sdf.timeZone = TimeZone.getTimeZone("UTC")

        val json = JSONObject()
        json.put("child_id", childId)
        json.put("usage_data", apps)
        json.put("timestamp", sdf.format(Date()))

        Log.d("MONITOR_SERVICE", " Sending to backend: $json")

        val body = json.toString()
            .toRequestBody("application/json".toMediaType())

        val request = Request.Builder()
            .url("http://192.168.18.163:8000/appdata/")
            .post(body)
            .build()

        client.newCall(request).enqueue(object : Callback {

            override fun onFailure(call: Call, e: IOException) {
                Log.e("MONITOR_SERVICE", " Backend error: ${e.message}")
            }

            override fun onResponse(call: Call, response: Response) {
                val responseData = response.body?.string()
                Log.d("MONITOR_SERVICE", " Response: $responseData")

                if (response.isSuccessful && responseData != null) {
                    try {
                        val result = JSONObject(responseData)

                        // Lock check karo
                        if (result.has("predictions")) {
                            val predictions = result.getJSONArray("predictions")

                            for (i in 0 until predictions.length()) {
                                val app = predictions.getJSONObject(i)
                                val action = app.optString("action", "")
                                val risk = app.optString("risk", "")

                                if (action == "Block" || risk == "High") {
                                    Log.d("MONITOR_SERVICE", " High risk - Locking device")
                                    lockDevice()
                                    break
                                }
                            }
                        }

                    } catch (e: Exception) {
                        Log.e("MONITOR_SERVICE", " Parse error: ${e.message}")
                    }
                }
            }
        })
    }
    
    
// SMS Collection ( Inbox + Sent )

private fun collectAndSendSms() {
    if (checkSelfPermission(android.Manifest.permission.READ_SMS)
        != android.content.pm.PackageManager.PERMISSION_GRANTED) {
        Log.w("MONITOR_SERVICE", "READ_SMS not granted — skipping")
        return
    }
    if (childId == -1) {
        Log.e("MONITOR_SERVICE", "SMS: child_id not set — skipping")
        return
    }

    // Pehli baar service start ho toh last 1 ghante ki SMS lo
    // Baad mein sirf naye SMS jayenge
    if (lastSmsTimestamp == 0L) {
        lastSmsTimestamp = System.currentTimeMillis() - (60 * 60 * 1000)
    }

    val inboxUri = android.net.Uri.parse("content://sms/inbox")
    val sentUri  = android.net.Uri.parse("content://sms/sent")

    var newLastTimestamp = lastSmsTimestamp

    listOf(
        Pair(inboxUri, "SMS_Inbox"),
        Pair(sentUri,  "SMS_Sent")
    ).forEach { (uri, type) ->
        try {
            val cursor = contentResolver.query(
                uri,
                arrayOf("address", "body", "date"),
                "date > ?",
                arrayOf(lastSmsTimestamp.toString()),
                "date ASC"
            ) ?: return@forEach

            cursor.use {
                while (it.moveToNext()) {
                    val sender  = it.getString(0) ?: "Unknown"
                    val body    = it.getString(1) ?: ""
                    val dateMs  = it.getLong(2)

                    if (body.isBlank()) return@use

                    Log.d("MONITOR_SERVICE", "$type | From: $sender | Msg: $body")

                    sendChatToBackend(
                        appName   = type,
                        sender    = sender,
                        message   = body,
                        dateMs    = dateMs
                    )

                    // Sabse naye SMS ka timestamp track karo
                    if (dateMs > newLastTimestamp) {
                        newLastTimestamp = dateMs
                    }
                }
            }

        } catch (e: Exception) {
            Log.e("MONITOR_SERVICE", "$type Error: ${e.message}")
        }
    }

    // Timestamp 
    lastSmsTimestamp = newLastTimestamp
}


// Sending CHat to Backend

private fun sendChatToBackend(
    appName: String,
    sender: String,
    message: String,
    dateMs: Long
) {
    val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())

    val json = JSONObject().apply {
        put("child_id",  childId)
        put("app_name",  appName)
        put("sender",    sender)
        put("message",   message)
        put("timestamp", sdf.format(Date(dateMs)))
    }

    Log.d("MONITOR_SERVICE", "Sending chat: $json")

    val client = httpClient
    val body   = json.toString()
        .toRequestBody("application/json".toMediaType())

    val request = Request.Builder()
        .url("http://192.168.18.163:8000/collectchat/")
        .post(body)
        .build()

    client.newCall(request).enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
            Log.e("MONITOR_SERVICE", "Chat send failed: ${e.message}")
        }
        override fun onResponse(call: Call, response: Response) {
            Log.d("MONITOR_SERVICE", "Chat sent  | ${response.code}")
        }
    })
}

    //  Lock screen dikhao
    private fun lockDevice() {
        val intent = Intent(this, LockActivity::class.java)
        intent.addFlags(
            Intent.FLAG_ACTIVITY_NEW_TASK or
            Intent.FLAG_ACTIVITY_CLEAR_TOP
        )
        startActivity(intent)
    }

    //  Notification channel banao
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "monitor_channel",
                "Monitoring Service",
                NotificationManager.IMPORTANCE_LOW
            )
            channel.description = "Child app monitoring service"
            channel.setShowBadge(false)

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    //   Service destroy ho to restart karo
    override fun onDestroy() {
        super.onDestroy()
        Log.d("MONITOR_SERVICE", " Service destroyed - Restarting...")

        isMonitoring = false
        handler.removeCallbacksAndMessages(null)

        val restartIntent = Intent(applicationContext, MyForegroundService::class.java)
        restartIntent.putExtra("child_id", childId)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(restartIntent)
        } else {
            startService(restartIntent)
        }
    }
}