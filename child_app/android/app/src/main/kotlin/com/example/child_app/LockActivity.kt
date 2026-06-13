package com.example.child_app

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine

class LockActivity : FlutterActivity() {

    override fun getInitialRoute(): String {
        return "/lock"   // Flutter side pe yeh route lockScreen() pe map hona chahiye
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Lock screen ke upar bhi dikhna chahiye, aur screen on rakho
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
        )
    }

    // Back button disable - child ise band na kar sake
    override fun onBackPressed() {
        // Nothing to do 
    }
}