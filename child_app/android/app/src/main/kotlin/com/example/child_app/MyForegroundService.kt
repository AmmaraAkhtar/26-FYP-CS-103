package com.example.child_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.app.usage.UsageStatsManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
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
import java.util.Calendar
import java.util.*

class MyForegroundService : Service() {

    companion object {
    var isDeviceLocked = false
    var childIdStatic = -1  // LockActivity access ke liye
    var isLockActivityInForeground = false
}

    private val handler = Handler(Looper.getMainLooper())
    private var childId: Int = -1
    private var isMonitoring = false
    private var tickCount = 0
    private var lastSmsTimestamp: Long = 0L
    private val httpClient = OkHttpClient.Builder()
        .connectTimeout(30, java.util.concurrent.TimeUnit.SECONDS)
        .readTimeout(30, java.util.concurrent.TimeUnit.SECONDS)
        .build()

    private var deviceLocked = false

    // ── Partial wake lock — Doze mode mein CPU ko sone se rokta hai
    // taake Handler.postDelayed() timers apne actual schedule (60s) ke
    // kareeb fire hon, na ke OS ke marzi se 3-7 minute delay ho jaye ──
    private var wakeLock: PowerManager.WakeLock? = null

    //  Unlock Receiver 
    private val unlockReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == "com.example.child_app.UNLOCK") {
            deviceLocked = false
            isDeviceLocked = false
            handler.post {
                LockOverlayManager.hide(this@MyForegroundService)  // ← this@MyForegroundService
            }
            val nm = getSystemService(NotificationManager::class.java)
            nm.cancel(99)
            Log.d("MONITOR_SERVICE", "Unlock broadcast received")
        }
    }
}
    //  Screen/Close Receiver — jab Close All ya screen on ho 
    private val screenReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_SCREEN_ON && deviceLocked) {
            Log.d("MONITOR_SERVICE", "Screen ON — relaunching LockActivity")
            handler.postDelayed({ showLockNotification() }, 300)
        }
    }
}
    // checkLockStatus
    private fun checkLockStatus() {
        if (childId == -1) return

        Thread {
            try {
                val url = "http://192.168.18.163:8000/check-lock-status/?child_id=$childId"
                val connection = java.net.URL(url).openConnection() as java.net.HttpURLConnection
                connection.requestMethod = "GET"
                connection.connectTimeout = 10000
                connection.readTimeout = 10000

                val response = connection.inputStream.bufferedReader().readText()
                val json = JSONObject(response)
                val shouldLock = json.getBoolean("is_locked")
                Log.d("MONITOR_SERVICE", "[LOCK_CHECK] shouldLock=$shouldLock | deviceLocked(local)=$deviceLocked | isDeviceLocked(companion)=$isDeviceLocked")

                if (shouldLock && !deviceLocked) {
                    deviceLocked = true
                    isDeviceLocked = true
                    handler.post { lockDevice() }
                } else if (!shouldLock && deviceLocked) {
                     deviceLocked = false
    isDeviceLocked = false
    handler.post {
        LockOverlayManager.hide(this@MyForegroundService)  // ← this@MyForegroundService
    }
    val nm = getSystemService(NotificationManager::class.java)
    nm.cancel(99)
    val unlockIntent = Intent("com.example.child_app.UNLOCK")
    sendBroadcast(unlockIntent)
                }

            } catch (e: Exception) {
                Log.e("MONITOR_SERVICE", "Lock check failed: ${e.message}")
            }
        }.start()
    }

    //  lockDevice
    
            fun lockDevice() {
    Log.d("MONITOR_SERVICE", "[LOCK_DEVICE] ENTERED")
    deviceLocked = true
    isDeviceLocked = true

    // Persist to backend
    if (childId != -1) {
        Thread {
            try {
                val json = JSONObject().apply { put("child_id", childId) }
                val body = json.toString().toRequestBody("application/json".toMediaType())
                val request = Request.Builder()
                    .url("http://192.168.18.163:8000/lock-device/")
                    .post(body).build()
                httpClient.newCall(request).execute().use {
                    Log.d("MONITOR_SERVICE", "Lock persisted | ${it.code}")
                }
            } catch (e: Exception) {
                Log.e("MONITOR_SERVICE", "Lock persist failed: ${e.message}")
            }
        }.start()
    }

    handler.post {
        // Show overlay immediately — works even from background
        if (android.provider.Settings.canDrawOverlays(this)) {
            LockOverlayManager.show(this)
        }
        showLockNotification()

        // Backup direct launch — apps holding the overlay (SYSTEM_ALERT_WINDOW)
        // permission are exempt from background-activity-start restrictions,
        // so this works even if the full-screen-intent notification gets
        // silently downgraded/ignored by the OS (common on Android 13/14+
        // or when USE_FULL_SCREEN_INTENT isn't granted).
        try {
            val directIntent = Intent(this, LockActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
            }
            startActivity(directIntent)
            Log.d("MONITOR_SERVICE", "Direct LockActivity start fired")
        } catch (e: Exception) {
            Log.e("MONITOR_SERVICE", "Direct LockActivity start failed: ${e.message}")
        }
    }
}
    // showLockNotification 
    

        
        
        

    private fun showLockNotification() {
        Log.d("MONITOR_SERVICE", "[SHOW_LOCK] ENTERED")
    val lockIntent = Intent(this, LockActivity::class.java).apply {
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
    }

    val pendingIntent = PendingIntent.getActivity(
        this, 0, lockIntent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val channel = NotificationChannel(
            "lock_channel", "Device Lock", NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Device lock notifications"
            setShowBadge(false)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        }
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }

    val notification = NotificationCompat.Builder(this, "lock_channel")
        .setContentTitle("Device Locked")
        .setContentText("This device has been locked by parent.")
        .setSmallIcon(android.R.drawable.ic_lock_lock)
        .setPriority(NotificationCompat.PRIORITY_HIGH)
        .setCategory(NotificationCompat.CATEGORY_ALARM)
        .setFullScreenIntent(pendingIntent, true)
        .setAutoCancel(false)
        .setOngoing(true)
        .build()

    getSystemService(NotificationManager::class.java).notify(99, notification)

    
}

    // isLockActivityVisible 
    private fun isLockActivityVisible(): Boolean {
        return try {
            val am = getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
            @Suppress("DEPRECATION")
            val tasks = am.getRunningTasks(1)
            tasks.firstOrNull()?.topActivity?.className == "com.example.child_app.LockActivity"
        } catch (e: Exception) {
            false
        }
    }

    //  onCreate 
    override fun onCreate() {
        super.onCreate()

        // Unlock receiver
        val unlockFilter = IntentFilter("com.example.child_app.UNLOCK")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(unlockReceiver, unlockFilter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(unlockReceiver, unlockFilter)
        }

        // Screen/Close receiver
        val screenFilter = IntentFilter().apply {
            addAction(Intent.ACTION_CLOSE_SYSTEM_DIALOGS)
            addAction(Intent.ACTION_SCREEN_ON)
        }
        registerReceiver(screenReceiver, screenFilter)

        createNotificationChannel()

        val notification: Notification =
            NotificationCompat.Builder(this, "monitor_channel")
                .setContentTitle("Child Monitoring Active")
                .setContentText("Monitoring apps in background")
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setOngoing(true)
                .build()

        startForeground(1, notification)

        // ── Acquire partial wake lock so background tick timers keep
        // firing close to schedule even when the screen is off / Doze kicks in ──
        try {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "ChildApp::MonitorWakeLock"
            )
            wakeLock?.setReferenceCounted(false)
            wakeLock?.acquire(12 * 60 * 60 * 1000L) // 12h safety timeout
            Log.d("MONITOR_SERVICE", "WakeLock acquired")
        } catch (e: Exception) {
            Log.e("MONITOR_SERVICE", "WakeLock acquire failed: ${e.message}")
        }

        Log.d("MONITOR_SERVICE", "Service Created")
    }

    // onStartCommand
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
    val intentChildId = intent?.getIntExtra("child_id", -1) ?: -1
    if (intentChildId != -1) {
        childId = intentChildId
        childIdStatic = intentChildId
    } else {
        val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        childId = prefs.getLong("flutter.child_id", -1L).toInt()
        childIdStatic = childId
    }

    // LockActivity ne relaunch request bheja — immediately lock karo
    val relaunchLock = intent?.getBooleanExtra("relaunch_lock", false) ?: false
    if (relaunchLock && deviceLocked) {
        Log.d("MONITOR_SERVICE", "Relaunch request received — showing lock immediately")
        handler.post { showLockNotification() }
        return START_STICKY
    }

    if (!isMonitoring) {
        isMonitoring = true
        startMonitoring()
    }
    return START_STICKY
}

    //  onTaskRemoved 
    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d("MONITOR_SERVICE", "App removed - Restarting service...")
        val restartIntent = Intent(applicationContext, MyForegroundService::class.java)
        restartIntent.putExtra("child_id", childId)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(restartIntent)
        } else {
            startService(restartIntent)
        }
        super.onTaskRemoved(rootIntent)
    }

    // startMonitoring 
    
                  
    private fun startMonitoring() {
    handler.removeCallbacksAndMessages(null)
    scheduleTick()
}


                
                    private fun scheduleTick() {
    handler.post(object : Runnable {
        override fun run() {
            tickCount++

            if (deviceLocked) {
                if (!LockOverlayManager.isShowing) {
                    Log.d("MONITOR_SERVICE", "Overlay not showing — reshowing")
                    if (android.provider.Settings.canDrawOverlays(this@MyForegroundService)) {
                        LockOverlayManager.show(this@MyForegroundService)
                    }
                    showLockNotification()
                }
                if (tickCount % 20 == 0) checkLockStatus()
                handler.postDelayed(this, 150L)
            } else {
                if (tickCount % 5 == 0)  collectAndSendSms()
                if (tickCount % 5 == 0) fetchAndSendData()
                if (tickCount % 2 == 0)  checkLockStatus()
                if (tickCount % 10 == 0) { sendHeartbeat(); checkAccessibilityStatus() }
                if (tickCount >= 1440)   tickCount = 0
                handler.postDelayed(this, 60_000L)
            }
        }
    })
}
                    
   
    // Accessibility 
    private fun isAccessibilityServiceEnabled(): Boolean {
        val enabledServices = Settings.Secure.getString(
            contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
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
        val body = json.toString().toRequestBody("application/json".toMediaType())
        val request = Request.Builder()
            .url("http://192.168.18.163:8000/sendalert/")
            .post(body).build()
        httpClient.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("MONITOR_SERVICE", "Accessibility alert failed: ${e.message}")
            }
            override fun onResponse(call: Call, response: Response) {
                Log.d("MONITOR_SERVICE", "Accessibility alert sent | ${response.code}")
            }
        })
    }

    // Heartbeat 
    private fun sendHeartbeat() {
        if (childId == -1) return
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        sdf.timeZone = TimeZone.getTimeZone("UTC")
        val json = JSONObject().apply {
            put("child_id", childId)
            put("timestamp", sdf.format(Date()))
        }
        val body = json.toString().toRequestBody("application/json".toMediaType())
        val request = Request.Builder()
            .url("http://192.168.18.163:8000/heartbeat/")
            .post(body).build()
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

    //  fetchAndSendData
    private fun fetchAndSendData() {
        try {
            val endTime = System.currentTimeMillis()
            val calendar = Calendar.getInstance()
            calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)
            calendar.set(Calendar.MILLISECOND, 0)
            val startTime = calendar.timeInMillis

            val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val stats = usageStatsManager.queryAndAggregateUsageStats(startTime, endTime)

            if (stats.isNullOrEmpty()) { Log.d("MONITOR_SERVICE", "No usage stats"); return }

            val appsArray = JSONArray()
            for ((_, app) in stats) {
                if (app.totalTimeInForeground > 30000) {
                    val obj = JSONObject()
                    obj.put("package_name", app.packageName)
                    obj.put("usage_time", app.totalTimeInForeground / 1000)
                    appsArray.put(obj)
                }
            }
            if (appsArray.length() > 0) sendToBackend(appsArray)

        } catch (e: Exception) {
            Log.e("MONITOR_SERVICE", "Error: ${e.message}")
        }
    }

    //  sendToBackend 
    private fun sendToBackend(apps: JSONArray) {
        if (childId == -1) { Log.e("MONITOR_SERVICE", "Child ID not set - skipping"); return }

        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        sdf.timeZone = TimeZone.getTimeZone("UTC")

        val json = JSONObject()
        json.put("child_id", childId)
        json.put("usage_data", apps)
        json.put("timestamp", sdf.format(Date()))

        val body = json.toString().toRequestBody("application/json".toMediaType())
        val request = Request.Builder()
            .url("http://192.168.18.163:8000/appdata/")
            .post(body).build()

        httpClient.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("MONITOR_SERVICE", "Backend error: ${e.message}")
            }
            override fun onResponse(call: Call, response: Response) {
                val responseData = response.body?.string()
                if (response.isSuccessful && responseData != null) {
                    try {
                        val result = JSONObject(responseData)
                        if (result.has("predictions")) {
                            val predictions = result.getJSONArray("predictions")
                            for (i in 0 until predictions.length()) {
                                val app = predictions.getJSONObject(i)
                                val action = app.optString("action", "").lowercase()
                                if (action == "block" || action == "escalate") {
                                    handler.post { lockDevice() }
                                }
                            }
                        }
                    } catch (e: Exception) {
                        Log.e("MONITOR_SERVICE", "Parse error: ${e.message}")
                    }
                }
            }
        })
    }

    // collectAndSendSms 
    private fun collectAndSendSms() {
        if (checkSelfPermission(android.Manifest.permission.READ_SMS)
            != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            Log.w("MONITOR_SERVICE", "READ_SMS not granted — skipping"); return
        }
        if (childId == -1) { Log.e("MONITOR_SERVICE", "SMS: child_id not set — skipping"); return }

        if (lastSmsTimestamp == 0L) {
            lastSmsTimestamp = System.currentTimeMillis() - (60 * 60 * 1000)
        }

        val inboxUri = android.net.Uri.parse("content://sms/inbox")
        val sentUri  = android.net.Uri.parse("content://sms/sent")
        var newLastTimestamp = lastSmsTimestamp

        listOf(Pair(inboxUri, "SMS_Inbox"), Pair(sentUri, "SMS_Sent")).forEach { (uri, type) ->
            try {
                val cursor = contentResolver.query(
                    uri, arrayOf("address", "body", "date"),
                    "date > ?", arrayOf(lastSmsTimestamp.toString()), "date ASC"
                ) ?: return@forEach

                cursor.use {
                    while (it.moveToNext()) {
                        val sender = it.getString(0) ?: "Unknown"
                        val body   = it.getString(1) ?: ""
                        val dateMs = it.getLong(2)
                        if (body.isBlank()) return@use
                        sendChatToBackend(appName = type, sender = sender, message = body, dateMs = dateMs)
                        if (dateMs > newLastTimestamp) newLastTimestamp = dateMs
                    }
                }
            } catch (e: Exception) {
                Log.e("MONITOR_SERVICE", "$type Error: ${e.message}")
            }
        }
        lastSmsTimestamp = newLastTimestamp
    }

    private fun sendChatToBackend(appName: String, sender: String, message: String, dateMs: Long) {
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
        val json = JSONObject().apply {
            put("child_id",  childId)
            put("app_name",  appName)
            put("sender",    sender)
            put("message",   message)
            put("timestamp", sdf.format(Date(dateMs)))
        }
        val body = json.toString().toRequestBody("application/json".toMediaType())
        val request = Request.Builder()
            .url("http://192.168.18.163:8000/collectchat/")
            .post(body).build()
        httpClient.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("MONITOR_SERVICE", "Chat send failed: ${e.message}")
            }
            override fun onResponse(call: Call, response: Response) {
                Log.d("MONITOR_SERVICE", "Chat sent | ${response.code}")
            }
        })
    }

    //  createNotificationChannel 
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "monitor_channel", "Monitoring Service", NotificationManager.IMPORTANCE_LOW
            )
            channel.description = "Child app monitoring service"
            channel.setShowBadge(false)
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    //  onDestroy 
    override fun onDestroy() {
        try { unregisterReceiver(unlockReceiver) } catch (_: Exception) {}
        try { unregisterReceiver(screenReceiver) } catch (_: Exception) {}

        // ── Release wake lock to avoid leaking it ──
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
                Log.d("MONITOR_SERVICE", "WakeLock released")
            }
        } catch (e: Exception) {
            Log.e("MONITOR_SERVICE", "WakeLock release failed: ${e.message}")
        }

        super.onDestroy()
        Log.d("MONITOR_SERVICE", "Service destroyed - Restarting...")

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

    //deactivateDeviceAdmin 
    private fun deactivateDeviceAdmin() {
        val deviceAdminComponent = android.content.ComponentName(
            this, MyDeviceAdminReceiver::class.java
        )
        val dpm = getSystemService(android.content.Context.DEVICE_POLICY_SERVICE)
                as android.app.admin.DevicePolicyManager
        if (dpm.isAdminActive(deviceAdminComponent)) {
            dpm.removeActiveAdmin(deviceAdminComponent)
        }
    }
}