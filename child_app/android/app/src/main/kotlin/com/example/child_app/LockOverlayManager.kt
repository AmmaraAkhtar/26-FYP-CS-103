package com.example.child_app

import android.content.Context
import android.graphics.PixelFormat
import android.os.Build
import android.view.Gravity
import android.view.WindowManager
import android.widget.FrameLayout
import android.view.View
import android.graphics.Color
import android.widget.TextView
import android.view.ViewGroup

object LockOverlayManager {

    private var overlayView: View? = null

    fun show(context: Context) {
        if (overlayView != null) return  // already showing

        val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        else
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams.TYPE_SYSTEM_ALERT

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            type,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.OPAQUE
        )
        params.gravity = Gravity.TOP or Gravity.START

        // Full screen black overlay with message
        val layout = FrameLayout(context).apply {
            setBackgroundColor(Color.BLACK)
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        }

        val text = TextView(context).apply {
            this.text = "Device Locked by Parent"
            setTextColor(Color.WHITE)
            textSize = 24f
            gravity = Gravity.CENTER
        }

        layout.addView(text, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT,
            Gravity.CENTER
        ))

        try {
            wm.addView(layout, params)
            overlayView = layout
        } catch (e: Exception) {
            android.util.Log.e("LockOverlay", "Failed to add overlay: ${e.message}")
        }
    }

    fun hide(context: Context) {
        overlayView?.let {
            try {
                val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
                wm.removeView(it)
            } catch (e: Exception) {
                android.util.Log.e("LockOverlay", "Failed to remove overlay: ${e.message}")
            }
            overlayView = null
        }
    }

    val isShowing: Boolean get() = overlayView != null
}