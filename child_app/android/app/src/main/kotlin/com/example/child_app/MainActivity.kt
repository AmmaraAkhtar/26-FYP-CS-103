package com.example.child_app

import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context


class MainActivity : FlutterActivity() {

    private val CHANNEL = "monitor_channel"
    override fun onResume() {
    super.onResume()

    if (MyForegroundService.isDeviceLocked) {
        val intent = Intent(this, LockActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }
    
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

                "openAutoStartSettings" -> {
                    openAutoStartSettings()
                    result.success("Opened")
                }

                "getManufacturer" -> {
                    result.success(Build.MANUFACTURER)
                }

                "activateDeviceAdmin" -> {
                    val deviceAdminComponent = ComponentName(
                        this,
                        MyDeviceAdminReceiver::class.java
                    )
                    
                    val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) 
                            as DevicePolicyManager
                    
                    if (!dpm.isAdminActive(deviceAdminComponent)) {
                        // Admin activation screen dikhao
                        val intent = Intent(
                            DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN
                        ).apply {
                            putExtra(
                                DevicePolicyManager.EXTRA_DEVICE_ADMIN,
                                deviceAdminComponent
                            )
                            putExtra(
                                DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                                "This app protects your child. Only parents can remove it."
                            )
                        }
                        startActivityForResult(intent, 1)
                        result.success("Activation screen opened")
                    } else {
                        result.success("Already active")
                    }
                }

                // Battery optimization case
                 "requestIgnoreBatteryOptimizations" -> {
                val pm = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
                if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
                    intent.data = android.net.Uri.parse("package:$packageName")
                    startActivity(intent)
                } else {
                    result.success("Already ignoring")
                    return@setMethodCallHandler
                }
                result.success("Requested")
            }

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

                "isAccessibilityServiceEnabled" -> {
                val enabledServices = Settings.Secure.getString(
                    contentResolver,
                    Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
                )
                val serviceName = "$packageName/.MyAccessibilityService"
                val isEnabled = enabledServices?.contains(packageName) == true
                result.success(isEnabled)
            }

            "openAccessibilitySettings" -> {
                val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                startActivity(intent)
                result.success("Opened")
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

        // auto start settings on restart of mobile phones

        private fun openAutoStartSettings() {
    val manufacturer = Build.MANUFACTURER.lowercase()
    val intent = Intent()

    try {
        when {
            manufacturer.contains("xiaomi") -> {
                intent.component = ComponentName(
                    "com.miui.securitycenter",
                    "com.miui.permcenter.autostart.AutoStartManagementActivity"
                )
            }
            manufacturer.contains("oppo") -> {
                intent.component = ComponentName(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.permission.startup.StartupAppListActivity"
                )
            }
            manufacturer.contains("vivo") -> {
                intent.component = ComponentName(
                    "com.vivo.permissionmanager",
                    "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"
                )
            }
            manufacturer.contains("samsung") -> {
                intent.component = ComponentName(
                    "com.samsung.android.lool",
                    "com.samsung.android.sm.ui.battery.BatteryActivity"
                )
            }
            manufacturer.contains("huawei") -> {
                intent.component = ComponentName(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"
                )
            }
            manufacturer.contains("oneplus") -> {
                intent.component = ComponentName(
                    "com.oneplus.security",
                    "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity"
                )
            }
            manufacturer.contains("asus") -> {
                intent.component = ComponentName(
                    "com.asus.mobilemanager",
                    "com.asus.mobilemanager.entry.FunctionActivity"
                ).apply {
                    putExtra("pkg", packageName)
                    putExtra("package", packageName)
                    action = "com.asus.mobilemanager.AUTOSTART_TARGET"
                }
            }
            else -> {
                // Generic fallback - app info / battery settings
                openAppDetailsSettings()
                return
            }
        }

        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)

    } catch (e: Exception) {
        Log.e("AUTOSTART", "Specific intent failed, falling back: ${e.message}")
        openAppDetailsSettings()
    }
}

private fun openAppDetailsSettings() {
    try {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        intent.data = android.net.Uri.parse("package:$packageName")
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    } catch (e: Exception) {
        Log.e("AUTOSTART", "Fallback also failed: ${e.message}")
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