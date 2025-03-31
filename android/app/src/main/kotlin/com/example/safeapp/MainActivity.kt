package com.example.safeapp

import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import com.example.safeapp.services.MyDeviceAdminReceiver
import android.view.WindowManager.LayoutParams
import android.view.WindowManager


class MainActivity : FlutterActivity() {

    private val CHANNEL = "device_admin_channel"
    // private val SCREEN_PROTECTION_CHANNEL = "safeapp/screen_protection"
    // private val SCREEN_PROTECTION_CHANNEL = "com.example.safeapp/launch"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        getWindow().addFlags(LayoutParams.FLAG_SECURE);

         // Enable screen protection initially
        // enableScreenProtection()

        // Check permissions when app starts
        checkPermissions()

        // Setup Flutter method channel
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestDeviceAdmin" -> {
                    requestDeviceAdmin()
                    result.success("Device Admin Request Sent")
                }
                else -> result.notImplemented()
            }
        }

        // MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, SCREEN_PROTECTION_CHANNEL).setMethodCallHandler { call, result ->
        //     if (call.method == "launchApp") {
        //         val packageName = call.argument<String>("package")
        //         val intent = packageManager.getLaunchIntentForPackage(packageName!!)
        //         if (intent != null) {
        //             startActivity(intent)
        //             result.success(null)
        //         } else {
        //             result.error("UNAVAILABLE", "App not found", null)
        //         }
        //     }
        // }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Device Admin MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestDeviceAdmin" -> {
                    requestDeviceAdmin()
                    result.success("Device Admin Request Sent")
                }
                else -> result.notImplemented()
            }
        }

        // Screen Protection MethodChannel
        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCREEN_PROTECTION_CHANNEL).setMethodCallHandler { call, result ->
        //     when (call.method) {
        //         "enableScreenProtection" -> {
        //             enableScreenProtection()
        //             result.success(null)
        //         }
        //         "disableScreenProtection" -> {
        //             disableScreenProtection()
        //             result.success(null)
        //         }
        //         else -> result.notImplemented()
        //     }
        // }
    }

    // private fun enableScreenProtection() {
    //     runOnUiThread {
    //         window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
    //         Log.d("SafeApp", "Screen protection enabled")
    //     }
    // }

    // private fun disableScreenProtection() {
    //     runOnUiThread {
    //         window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    //         Log.d("SafeApp", "Screen protection disabled")
    //     }
    // }

    private fun checkPermissions() {
        if (!isAccessibilityEnabled()) {
            Log.d("Permissions", "Accessibility Service Not Enabled")
        }
        if (!isUsageStatsEnabled()) {
            Log.d("Permissions", "Usage Stats Not Enabled")
        }
        if (!isDeviceAdminEnabled()) {
            Log.d("Permissions", "Device Admin Not Enabled")
        }
    }

    private fun isAccessibilityEnabled(): Boolean {
        val serviceId = "${packageName}/.services.MyAccessibilityService"
        return Settings.Secure.getString(contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
            ?.contains(serviceId) == true
    }

    private fun isUsageStatsEnabled(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName)
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun isDeviceAdminEnabled(): Boolean {
        val devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val componentName = ComponentName(this, MyDeviceAdminReceiver::class.java)
        return devicePolicyManager.isAdminActive(componentName)
    }

    private fun requestDeviceAdmin() {
        val componentName = ComponentName(this, MyDeviceAdminReceiver::class.java)
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName)
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "This app requires Device Admin permissions for security purposes.")
        startActivity(intent)
    }
}
