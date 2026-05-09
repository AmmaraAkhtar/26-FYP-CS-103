package com.example.child_app

import android.app.*
import android.content.Context
import android.content.Intent
import android.app.usage.UsageStatsManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat

class MyForegroundService : Service() {

    private val handler = Handler(Looper.getMainLooper())

    override fun onCreate() {
        super.onCreate()

        createNotificationChannel()

        val notification = NotificationCompat.Builder(this, "monitor_channel")
            .setContentTitle("Child Monitoring Active")
            .setContentText("Monitoring app activity...")
            .setSmallIcon(android.R.drawable.ic_menu_info_details)
            .build()

        startForeground(1, notification)

        startMonitoring()
    }

    private fun startMonitoring() {

        handler.post(object : Runnable {
            override fun run() {

                val endTime = System.currentTimeMillis()
                val startTime = endTime - (1000 * 60)

                val usageStats =
                    getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

                val stats = usageStats.queryUsageStats(
                    UsageStatsManager.INTERVAL_DAILY,
                    startTime,
                    endTime
                )

                for (app in stats) {

                    if (app.totalTimeInForeground > 0) {

                        println("APP: ${app.packageName}")
                        println("TIME: ${app.totalTimeInForeground}")
                    }
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

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}