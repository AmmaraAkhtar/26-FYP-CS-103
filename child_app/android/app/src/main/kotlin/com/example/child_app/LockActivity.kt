package com.example.child_app

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class LockActivity : FlutterActivity() {

    private var isUnlocked = false
    private var bringToFrontScheduled = false
    private var isReordering = false  // REORDER_TO_FRONT track karne ke liye
    override fun getCachedEngineId(): String? = null
    override fun getInitialRoute(): String = "/lock"

    private val unlockReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == "com.example.child_app.UNLOCK") {
                isUnlocked = true
                MyForegroundService.isDeviceLocked = false
                cancelLockNotification()
                finish()
            }
        }
    }

    private val handler = Handler(Looper.getMainLooper())

    private val pollRunnable = object : Runnable {
        override fun run() {
            if (!MyForegroundService.isDeviceLocked) {
                isUnlocked = true
                cancelLockNotification()
                finish()
                return
            }
            handler.postDelayed(this, 3000)
        }
    }

    //override fun getInitialRoute(): String = "/lock"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }
        @Suppress("DEPRECATION")
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON 
            //or
            //WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
        )

        val filter = IntentFilter("com.example.child_app.UNLOCK")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(unlockReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(unlockReceiver, filter)
        }

        handler.postDelayed(pollRunnable, 3000)
    }

    override fun onResume() {
        super.onResume()
        isReordering = false
        bringToFrontScheduled = false

        if (!MyForegroundService.isDeviceLocked) {
            isUnlocked = true
            cancelLockNotification()
            finish()
        }
    }

    override fun onStop() {
    super.onStop()
    if (MyForegroundService.isDeviceLocked && !isUnlocked) {
        isReordering = true
        bringToFront()
        signalServiceToRelaunch()
    }
}

    override fun onWindowFocusChanged(hasFocus: Boolean) {
    super.onWindowFocusChanged(hasFocus)
    if (!hasFocus && MyForegroundService.isDeviceLocked && !isUnlocked) {
        bringToFront()
    }
}

    override fun onUserLeaveHint() {
    super.onUserLeaveHint()
    if (MyForegroundService.isDeviceLocked && !isUnlocked) {
        bringToFront()
    }
}

    override fun onPause() {
        super.onPause()
        // Kuch nahi — onStop handle karega
    }

    private fun signalServiceToRelaunch() {
        try {
            val intent = Intent(this, MyForegroundService::class.java)
            intent.putExtra("relaunch_lock", true)
            intent.putExtra("child_id", MyForegroundService.childIdStatic)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
            Log.d("LockActivity", "Service ko relaunch signal bheja")
        } catch (e: Exception) {
            Log.e("LockActivity", "Signal failed: ${e.message}")
        }
    }

    private fun bringToFront() {
    if (isUnlocked || !MyForegroundService.isDeviceLocked) return
    val intent = Intent(this, LockActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
    }
    startActivity(intent)
}

    private fun cancelLockNotification() {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.cancel(99)
    }

    override fun onBackPressed() {
        // Disabled
    }

    override fun finish() {
        if (isUnlocked || !MyForegroundService.isDeviceLocked) {
            super.finish()
        }
    }

    override fun onDestroy() {
        handler.removeCallbacks(pollRunnable)
        try { unregisterReceiver(unlockReceiver) } catch (_: Exception) {}
        super.onDestroy()
    }
}