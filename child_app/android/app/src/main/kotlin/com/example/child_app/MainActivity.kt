package com.example.child_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val MONITOR_CHANNEL = "monitor_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Chat channel (existing)
        MyAccessibilityService.channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "chat_reader_channel"
        )

        // Monitor channel (NEW)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MONITOR_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "startService" -> {
                    startMonitorService()
                    result.success("Foreground Service Started")
                }

                "stopService" -> {
                    stopMonitorService()
                    result.success("Foreground Service Stopped")
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun startMonitorService() {
        val intent = Intent(this, MyForegroundService::class.java)
        startForegroundService(intent)
    }

    private fun stopMonitorService() {
        val intent = Intent(this, MyForegroundService::class.java)
        stopService(intent)
    }
}