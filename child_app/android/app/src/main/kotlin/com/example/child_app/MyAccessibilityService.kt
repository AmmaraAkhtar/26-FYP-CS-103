package com.example.yourapp

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class MyAccessibilityService : AccessibilityService() {

    companion object {
        var channel: MethodChannel? = null
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        val text = event.text.toString()
        if (text.isNotEmpty()) {
            // Send text to Flutter via MethodChannel
            channel?.invokeMethod("onChatText", text)
        }
    }

    override fun onInterrupt() {}
}