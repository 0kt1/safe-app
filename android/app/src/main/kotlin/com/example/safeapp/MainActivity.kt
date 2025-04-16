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
// import com.example.safeapp.services.AppBlockerService
import android.util.Log
import android.view.WindowManager.LayoutParams

import android.content.pm.ApplicationInfo
import android.provider.Settings
import android.app.AlertDialog
import android.widget.Toast
import android.view.accessibility.AccessibilityManager
import android.view.accessibility.AccessibilityEvent
import android.accessibilityservice.AccessibilityService
import android.content.SharedPreferences

import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Base64
import java.io.ByteArrayOutputStream

import android.accessibilityservice.AccessibilityServiceInfo
import android.app.AppOpsManager
import android.telephony.TelephonyManager
import io.flutter.plugin.common.MethodCall

import io.flutter.embedding.android.FlutterFragmentActivity

// class MainActivity : FlutterActivity() {
class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.safeapp/app_blocker"
    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var adminComponent: ComponentName
    private val SIM_PREF_KEY = "sim_serial"

     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // getWindow().addFlags(LayoutParams.FLAG_SECURE); // Enable screen protection

        // Enable screen protection initially
        // enableScreenProtection()

        // Check permissions when app starts
        // checkPermissions()

        // // Setup Flutter method channel
        // MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        //     when (call.method) {
        //         "requestDeviceAdmin" -> {
        //             requestDeviceAdmin()
        //             result.success("Device Admin Request Sent")
        //         }
        //         else -> result.notImplemented()
        //     }
        // }

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

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        adminComponent = ComponentName(this, MyDeviceAdminReceiver::class.java)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestAdmin" -> requestAdmin(result)
                // "startBlocking" -> startBlockingService(result)
                // "stopBlocking" -> stopBlockingService(result)
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
                "getFilteredApps" -> {
                    val allApps = getInstalledApps()
                    val filteredApps = filterNonPlayStoreApps(allApps)
                    result.success(filteredApps)  // Return list of filtered app package names
                }
                "uninstallApps" -> {
                    val appsToUninstall = call.arguments as List<String>
                    uninstallApps(appsToUninstall)
                    result.success("Selected apps are being uninstalled.")
                }
                "openAccessibilitySettings" -> {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                    result.success(null)
                }
                "launchApp" -> {
                    val packageName = call.argument<String>("package")
                    if (packageName != null) {
                        launchAppFromSafeApp(this, packageName)
                        result.success("Launching app: $packageName")
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                }
                "isAccessibilityServiceEnabled" -> result.success(checkAccessibilityService())
                "isOverlayEnabled" -> result.success(checkOverlayPermission())
                "isSystemApp" -> result.success(isSystemApp(call.arguments<String?>() ?: ""))
                "isPreInstalled" -> result.success(isPreInstalledApp(call.arguments<String?>() ?: ""))
                "getInstaller" -> result.success(getInstallerSource(call.arguments<String?>() ?: ""))
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

    // private fun startBlockingService(result: MethodChannel.Result) {
    //     val intent = Intent(this, AppBlockerService::class.java)
    //     startService(intent)
    //     result.success(null)
    // }

    // private fun stopBlockingService(result: MethodChannel.Result) {
    //     val intent = Intent(this, AppBlockerService::class.java)
    //     stopService(intent)
    //     result.success(null)
    // }

    private fun setBlockedApps(apps: List<String>, result: MethodChannel.Result) {
        AppBlockerPreferences(this).setBlockedApps(apps.toSet())
        result.success(null)
    }

    private fun getBlockedApps(result: MethodChannel.Result) {
        val apps = AppBlockerPreferences(this).getBlockedApps().toList()
        result.success(apps)
    }


    // ============================================================
    // from safe_app_test

    private fun getInstalledApps(): List<Map<String, String>> {
        val pm: PackageManager = packageManager
        val packages = pm.getInstalledPackages(0)

        val installedApps = mutableListOf<Map<String, String>>()

    for (packageInfo in packages) {
        val appName = packageInfo.applicationInfo.loadLabel(pm).toString()
        val packageName = packageInfo.packageName
        val icon = packageInfo.applicationInfo.loadIcon(pm) // Fetch the app icon

        // Convert the icon to a Base64 string (Flutter can't directly read Drawable)
        val iconBase64 = encodeDrawableToBase64(icon)

        installedApps.add(
            mapOf(
                "packageName" to packageName,
                "appName" to appName,
                "icon" to iconBase64
            )
        )
    }

    return installedApps
        // return packages.map { it.packageName }
    }

    private fun filterNonPlayStoreApps(apps: List<Map<String, String>>): List<Map<String, String>> {
        val nonPlayStoreApps = mutableListOf<Map<String, String>>()

        // for (packageName in apps) {
        //     try {
        //         val installer = packageManager.getInstallerPackageName(packageName)
        //         val appInfo = packageManager.getApplicationInfo(packageName, 0)

        //         if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0) { // Ignore system apps
        //             if (installer == null || installer != "com.android.vending") {
        //                 nonPlayStoreApps.add(packageName)
        //             }
        //         }
        //     } catch (e: Exception) {
        //         Log.e("AppFilter", "Error checking installer for $packageName", e)
        //     }
        // }
        // return nonPlayStoreApps

        for (app in apps) {
        val packageName = app["packageName"] ?: continue
        try {
            val installer = packageManager.getInstallerPackageName(packageName)
            val appInfo = packageManager.getApplicationInfo(packageName, 0)

            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0) { // Ignore system apps
                if (installer == null || installer != "com.android.vending") {
                    nonPlayStoreApps.add(app)
                }
            }
        } catch (e: Exception) {
            Log.e("AppFilter", "Error checking installer for $packageName", e)
        }
    }
    return nonPlayStoreApps
    }

    private fun uninstallApps(apps: List<String>) {
        for (app in apps) {
            val intent = android.content.Intent(android.content.Intent.ACTION_DELETE)
            intent.data = android.net.Uri.parse("package:$app")
            startActivity(intent)
        }
    }


    // =============================================================
    //  

    // Convert drawable icon to Base64 (Flutter can't use Android drawables directly)
    private fun encodeDrawableToBase64(drawable: Drawable): String {
    val bitmap = when (drawable) {
        is BitmapDrawable -> drawable.bitmap
        is android.graphics.drawable.AdaptiveIconDrawable -> {
            val width = drawable.intrinsicWidth
            val height = drawable.intrinsicHeight
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = android.graphics.Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        }
        else -> {
            Log.e("DrawableError", "Unsupported drawable type: ${drawable::class.java}")
            return ""
        }
    }

    val stream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
    val byteArray = stream.toByteArray()
    return Base64.encodeToString(byteArray, Base64.NO_WRAP)
}


    fun launchAppFromSafeApp(context: Context, packageName: String) {
        val sharedPrefs = context.getSharedPreferences("SafeAppPrefs", Context.MODE_PRIVATE)
        sharedPrefs.edit().putBoolean("launched_from_safeapp", true).apply()

        // Log for debugging
        Log.d("SafeApp", "Flag set: launched_from_safeapp = true")

        val intent = context.packageManager.getLaunchIntentForPackage(packageName)
        intent?.putExtra("launched_from_safeapp", true)
        context.startActivity(intent)
    }




    fun sendCustomAccessibilityEvent() {
        val accessibilityManager = getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
        if (accessibilityManager.isEnabled) {
            Log.d("AccessibilityEvent", "Sending custom accessibility event")
            val event = AccessibilityEvent.obtain(AccessibilityEvent.TYPE_ANNOUNCEMENT)
            event.packageName = packageName
            event.className = "SafeAppEvent"
            event.text.add("SAFE_APP_LAUNCH")
            accessibilityManager.sendAccessibilityEvent(event)
        }
    }




    // =============================================================
    // from otp

    // ✅ Check if Accessibility Services are enabled
    private fun checkAccessibilityService(): List<String> {
        val accessibilityManager = getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
        val enabledServices = mutableListOf<String>()

        if (accessibilityManager.isEnabled) {
            val serviceList = accessibilityManager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
            for (service in serviceList) {
                enabledServices.add(service.resolveInfo.serviceInfo.packageName)
            }
        }
        return enabledServices
    }

    // ✅ Check if overlay permission is enabled
    private fun checkOverlayPermission(): List<String> {
        val overlayApps = mutableListOf<String>()
        val appOpsManager = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val installedApps = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)

        for (app in installedApps) {
            try {
                val mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_SYSTEM_ALERT_WINDOW, app.uid, app.packageName)
                if (mode == AppOpsManager.MODE_ALLOWED) {
                    overlayApps.add(app.packageName)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        return overlayApps
    }

    // ✅ Check if an App is a System App
    private fun isSystemApp(packageName: String): Boolean {
        return try {
            val packageInfo = packageManager.getApplicationInfo(packageName, 0)
            (packageInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }


    // ✅ Check if an App is Pre-Installed
    private fun isPreInstalledApp(packageName: String): Boolean {
        return try {
            val packageInfo = packageManager.getApplicationInfo(packageName, 0)
            (packageInfo.flags and (ApplicationInfo.FLAG_SYSTEM or ApplicationInfo.FLAG_UPDATED_SYSTEM_APP)) != 0
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    // ✅ Get Installer Source (Play Store, Sideload, etc.)
    private fun getInstallerSource(packageName: String): String {
        return try {
            packageManager.getInstallerPackageName(packageName) ?: "Unknown"
        } catch (e: Exception) {
            "Unknown"
        }
    }
    
}