package com.example.child_app

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "monitor_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Existing chat channel
        MyAccessibilityService.channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "chat_reader_channel"
        )

        // Foreground service channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "startService") {

                val childId = call.argument<Int>("child_id") ?: -1

                val intent = Intent(this, MyForegroundService::class.java)
                intent.putExtra("child_id", childId)

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    startForegroundService(intent)
                } else {
                    startService(intent)
                }

                result.success("Service Started")

            } else {
                result.notImplemented()
            }
        }
    }
    val vpnChannel = MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "vpn_channel"
    )

    MyVpnService.channel = vpnChannel

}