// package com.example.safeapp

// import android.app.admin.DevicePolicyManager
// import android.content.ComponentName
// import android.content.Context
// import android.content.Intent
// import android.os.Bundle
// import androidx.annotation.NonNull
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import com.example.safeapp.services.MyDeviceAdminReceiver
// import com.example.safeapp.services.AppBlockerService
// import android.provider.Settings
// import com.example.safeapp.services.AppBlockerPreferences

// class MainActivity : FlutterActivity() {
//     private val CHANNEL = "com.example.safeapp/app_blocker"
//     private lateinit var devicePolicyManager: DevicePolicyManager
//     private lateinit var adminComponent: ComponentName

//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
        
//         devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         adminComponent = ComponentName(this, MyDeviceAdminReceiver::class.java)

//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             when (call.method) {
//                 "requestAdmin" -> requestAdmin(result)
//                 "startBlocking" -> startBlockingService(result)
//                 "stopBlocking" -> stopBlockingService(result)
//                 "setBlockedApps" -> {
//                     val apps = call.argument<List<String>>("apps")
//                     setBlockedApps(apps ?: emptyList(), result)
//                 }
//                 "getBlockedApps" -> getBlockedApps(result)
//                 "forceStopApp" -> {
//                     val packageName = call.argument<String>("packageName")
//                     if (packageName != null) {
//                         forceStopApp(packageName, result)
//                     } else {
//                         result.error("INVALID_ARG", "Package name required", null)
//                     }
//                 }
//                 else -> result.notImplemented()
//             }
//         }
//     }

//     private fun forceStopApp(packageName: String, result: MethodChannel.Result) {
//         try {
//             if (devicePolicyManager.isAdminActive(adminComponent)) {
//                 try {
//                     // Using reflection as fallback
//                     val method: Method = DevicePolicyManager::class.java.getMethod(
//                         "forceStopPackage", 
//                         String::class.java
//                     )
//                     method.invoke(devicePolicyManager, packageName)
//                     result.success(true)
//                 } catch (e: Exception) {
//                     result.error("REFLECTION_FAILED", "Couldn't invoke forceStopPackage", null)
//                 }
//             } else {
//                 result.error("ADMIN_REQUIRED", "Admin rights not active", null)
//             }
//         } catch (e: Exception) {
//             result.error("FORCE_STOP_FAILED", e.message, null)
//         }
//     }


//     private fun requestAdmin(result: MethodChannel.Result) {
//         val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
//             putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent)
//             putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Required to block apps")
//         }
//         startActivity(intent)
//         result.success(null)
//     }

//     private fun startBlockingService(result: MethodChannel.Result) {
//         val intent = Intent(this, AppBlockerService::class.java)
//         startService(intent)
//         result.success(null)
//     }

//     private fun stopBlockingService(result: MethodChannel.Result) {
//         val intent = Intent(this, AppBlockerService::class.java)
//         stopService(intent)
//         result.success(null)
//     }

//     private fun setBlockedApps(apps: List<String>, result: MethodChannel.Result) {
//         AppBlockerPreferences(this).setBlockedApps(apps.toSet())
//         result.success(null)
//     }

//     private fun getBlockedApps(result: MethodChannel.Result) {
//         val apps = AppBlockerPreferences(this).getBlockedApps().toList()
//         result.success(apps)
//     }

//     private fun requestUsageStatsPermission() {
//         val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//         startActivity(intent)
//     }
// }



package com.example.safeapp

import android.app.ActivityManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.safeapp.services.MyDeviceAdminReceiver
import com.example.safeapp.services.AppBlockerPreferences
import java.lang.reflect.Method
import com.example.safeapp.services.AppBlockerService
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.safeapp/app_blocker"
    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var adminComponent: ComponentName

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        adminComponent = ComponentName(this, MyDeviceAdminReceiver::class.java)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestAdmin" -> requestAdmin(result)
                "startBlocking" -> startBlockingService(result)
                "stopBlocking" -> stopBlockingService(result)
                "setBlockedApps" -> {
                    val apps = call.argument<List<String>>("apps")
                    setBlockedApps(apps ?: emptyList(), result)
                }
                "getBlockedApps" -> getBlockedApps(result)
                "forceStopApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        forceStopApp(packageName, result)
                    } else {
                        result.error("INVALID_ARG", "Package name required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    // private fun forceStopApp(packageName: String, result: MethodChannel.Result) {
    //     try {
    //         if (devicePolicyManager.isAdminActive(adminComponent)) {
    //             try {
    //                 // Get the forceStopPackage method via reflection
    //                 val forceStopMethod: Method = DevicePolicyManager::class.java
    //                     .getDeclaredMethod("forceStopPackage", String::class.java)
                    
    //                 // Invoke the method
    //                 forceStopMethod.invoke(devicePolicyManager, packageName)
    //                 result.success(true)
    //             } catch (e: Exception) {
    //                 result.error("REFLECTION_ERROR", "Failed to force stop: ${e.message}", null)
    //             }
    //         } else {
    //             result.error("ADMIN_REQUIRED", "Admin rights not active", null)
    //         }
    //     } catch (e: Exception) {
    //         result.error("FORCE_STOP_FAILED", e.message, null)
    //     }
    // }

    private fun forceStopApp(packageName: String, result: MethodChannel.Result) {
    try {
        if (devicePolicyManager.isAdminActive(adminComponent)) {
            try {
                // Method 1: Try standard approach first
                // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                //     devicePolicyManager.forceStopPackage(packageName)
                //     result.success(true)
                //     return
                // }

                 try {
                    // Get the forceStopPackage method via reflection
                    val forceStopMethod: Method = DevicePolicyManager::class.java
                        .getDeclaredMethod("forceStopPackage", String::class.java)
                    
                    // Invoke the method
                    forceStopMethod.invoke(devicePolicyManager, packageName)
                    result.success(true)
                } catch (e: Exception) {
                    Log.e("AppBlocker 1", "Disable/enable failed", e)

                    result.error("REFLECTION_ERROR", "Failed to force stop: ${e.message}", null)
                }

                try {
                
                    // Method 2: Alternative approach for older devices
                    val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    activityManager.killBackgroundProcesses(packageName)
                } catch (e: Exception) {
                    Log.e("AppBlocker 2", "Disable/enable failed", e)
                }

                try{
                    // Method 3: Additional measure
                    val pm = packageManager
                    pm.setApplicationEnabledSetting(
                        packageName,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED_USER,
                        0
                    )
                    pm.setApplicationEnabledSetting(
                        packageName,
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                        0
                    )
                } catch (e: Exception) {
                    Log.e("AppBlocker 3", "Disable/enable failed", e)
                }
                
                result.success(true)
            } catch (e: Exception) {
                result.error("STOP_FAILED", "Couldn't force stop package", null)
            }
        } else {
            result.error("ADMIN_REQUIRED", "Admin rights not active", null)
        }
    } catch (e: Exception) {
        result.error("ERROR", "Force stop failed: ${e.message}", null)
    }
}

    private fun requestAdmin(result: MethodChannel.Result) {
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent)
            putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Required to block apps")
        }
        startActivity(intent)
        result.success(null)
    }

    private fun startBlockingService(result: MethodChannel.Result) {
        val intent = Intent(this, AppBlockerService::class.java)
        startService(intent)
        result.success(null)
    }

    private fun stopBlockingService(result: MethodChannel.Result) {
        val intent = Intent(this, AppBlockerService::class.java)
        stopService(intent)
        result.success(null)
    }

    private fun setBlockedApps(apps: List<String>, result: MethodChannel.Result) {
        AppBlockerPreferences(this).setBlockedApps(apps.toSet())
        result.success(null)
    }

    private fun getBlockedApps(result: MethodChannel.Result) {
        val apps = AppBlockerPreferences(this).getBlockedApps().toList()
        result.success(apps)
    }
}