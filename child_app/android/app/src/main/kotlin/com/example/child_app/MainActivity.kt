package com.example.child_app

import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "monitor_channel"
    override fun onResume() {
    super.onResume()
    MyAccessibilityService.channel = MethodChannel(
        flutterEngine!!.dartExecutor.binaryMessenger,
        "chat_reader_channel"
    )
}

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Accessibility Service channel
        MyAccessibilityService.channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "chat_reader_channel"
        )

        // Foreground + Notification Listener channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                // App Monitoring Service Start 
                "startService" -> {
                    val childId = call.argument<Int>("child_id") ?: -1
                    val intent  = Intent(this, MyForegroundService::class.java)
                    intent.putExtra("child_id", childId)

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }

                    result.success("Service Started")
                }

                // Notification Listener Check
                "isNotificationListenerEnabled" -> {
                    val enabledListeners = Settings.Secure.getString(
                        contentResolver,
                        "enabled_notification_listeners"
                    )
                    val isEnabled = enabledListeners
                        ?.contains(packageName) == true

                    result.success(isEnabled)
                }

                else -> result.notImplemented()
            }
        }

        // VPN channel
        val vpnChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "vpn_channel"
        )
        MyVpnService.channel = vpnChannel
    }
}