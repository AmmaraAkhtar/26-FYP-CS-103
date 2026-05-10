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
import androidx.core.app.NotificationCompat

import okhttp3.Call
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response

import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import java.text.SimpleDateFormat
import java.util.*

import org.json.JSONArray
import org.json.JSONObject

import java.io.IOException

class MyForegroundService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var childId: Int = -1

override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

    childId = intent?.getIntExtra("child_id", -1) ?: -1

    Log.d("MONITOR_SERVICE", "Child ID: $childId")

    return START_STICKY
}

    override fun onCreate() {
        super.onCreate()

        createNotificationChannel()

        val notification: Notification =
            NotificationCompat.Builder(this, "monitor_channel")
                .setContentTitle("Child Monitoring Active")
                .setContentText("Monitoring apps in background")
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .build()

        startForeground(1, notification)

        Log.d("MONITOR_SERVICE", "Service Started")

        startMonitoring()
    }
    override fun onTaskRemoved(rootIntent: Intent?) {
    val restartIntent = Intent(applicationContext, MyForegroundService::class.java)
    startService(restartIntent)

    super.onTaskRemoved(rootIntent)
}

    private fun lockDevice() {

        val intent = Intent(this, LockActivity::class.java)

        intent.addFlags(
            Intent.FLAG_ACTIVITY_NEW_TASK or
            Intent.FLAG_ACTIVITY_CLEAR_TOP
        )

        startActivity(intent)
    }

    private fun sendToBackend(apps: JSONArray) {

        val client = OkHttpClient()

        val json = JSONObject()

        json.put("child_id", childId)
        json.put("usage_data", apps)
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        sdf.timeZone = TimeZone.getTimeZone("UTC")
        json.put("timestamp", sdf.format(Date()))

        val body = json.toString()
            .toRequestBody("application/json".toMediaType())

        val request = Request.Builder()
            .url("http://192.168.18.163:8000/appdata/")
            .post(body)
            .build()

        client.newCall(request).enqueue(object : Callback {

            override fun onFailure(call: Call, e: IOException) {

                Log.e("API_ERROR", e.message ?: "Unknown Error")
            }

            override fun onResponse(call: Call, response: Response) {

                val responseData = response.body?.string()

                Log.d("API_RESPONSE", responseData ?: "No Response")

                if (responseData != null &&
                    responseData.contains("High")
                ) {

                    //lockDevice()
                }
            }
        })
    }

    private fun startMonitoring() {

        handler.post(object : Runnable {

            override fun run() {

                try {

                    val endTime = System.currentTimeMillis()
                    val startTime = endTime - (1000 * 60)

                    val usageStatsManager =
                        getSystemService(Context.USAGE_STATS_SERVICE)
                                as UsageStatsManager

                    val stats = usageStatsManager.queryUsageStats(
                        UsageStatsManager.INTERVAL_DAILY,
                        startTime,
                        endTime
                    )

                    val appsArray = JSONArray()

                    for (app in stats) {

                        if (app.totalTimeInForeground > 0) {

                            val obj = JSONObject()

                            obj.put("package_name", app.packageName)
                            obj.put(
                                "usage_time",
                                app.totalTimeInForeground / 1000
                            )

                            appsArray.put(obj)
                        }
                    }

                    if (appsArray.length() > 0) {

                        sendToBackend(appsArray)
                    }

                } catch (e: Exception) {

                    Log.e(
                        "MONITOR_SERVICE",
                        "ERROR: ${e.message}"
                    )
                }

                handler.postDelayed(this, 10000)
            }
        })
    }

    private fun createNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel = NotificationChannel(
                "monitor_channel",
                "Monitoring Service",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager =
                getSystemService(NotificationManager::class.java)

            manager.createNotificationChannel(channel)
        }
    }
    override fun onBind(intent: Intent?): IBinder? {
    return null
}

    
}