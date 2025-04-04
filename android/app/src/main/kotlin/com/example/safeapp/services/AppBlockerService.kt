// // package com.example.safeapp.services

// // import android.app.Service
// // import android.app.UsageStatsManager
// // import android.app.admin.DevicePolicyManager
// // import android.content.ComponentName
// // import android.content.Context
// // import android.content.Intent
// // import android.os.IBinder
// // import android.os.Build
// // import android.util.Log
// // import java.util.concurrent.Executors
// // import java.util.concurrent.TimeUnit

// // class AppBlockerService : Service() {
// //     private val executor = Executors.newSingleThreadScheduledExecutor()
// //     private lateinit var devicePolicyManager: DevicePolicyManager
// //     private lateinit var adminComponent: ComponentName
// //     private lateinit var prefs: AppBlockerPreferences

// //     override fun onCreate() {
// //         super.onCreate()
// //         devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
// //         adminComponent = DeviceAdminReceiver.getComponentName(this)
// //         prefs = AppBlockerPreferences(this)
// //         startBlocking()
// //     }

// //     private fun startBlocking() {
// //         executor.scheduleAtFixedRate({
// //             val blockedApps = prefs.getBlockedApps()
// //             if (blockedApps.isNotEmpty()) {
// //                 checkAndBlockApps(blockedApps)
// //             }
// //         }, 0, 3, TimeUnit.SECONDS) // Check every 3 seconds
// //     }

// //     private fun checkAndBlockApps(blockedApps: Set<String>) {
// //         val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
// //         val endTime = System.currentTimeMillis()
// //         val stats = usageStatsManager.queryUsageStats(
// //             UsageStatsManager.INTERVAL_DAILY,
// //             endTime - 1000 * 10, // Last 10 seconds
// //             endTime
// //         )

// //         stats?.forEach { usageStats ->
// //             if (blockedApps.contains(usageStats.packageName)) {
// //                 forceStopApp(usageStats.packageName)
// //             }
// //         }
// //     }

// //     private fun forceStopApp(packageName: String) {
// //         try {
// //             // Method 1: Force stop using DevicePolicyManager (most effective)
// //             if (devicePolicyManager.isAdminActive(adminComponent)) {
// //                 devicePolicyManager.forceStopPackage(packageName)
// //                 Log.d("AppBlocker", "Force stopped (admin): $packageName")
// //                 return
// //             }

// //             // Method 2: Alternative for non-admin (less effective)
// //             val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
// //             activityManager.killBackgroundProcesses(packageName)
// //             Log.d("AppBlocker", "Killed background: $packageName")

// //         } catch (e: SecurityException) {
// //             Log.e("AppBlocker", "Permission denied for $packageName", e)
// //         } catch (e: Exception) {
// //             Log.e("AppBlocker", "Error stopping $packageName", e)
// //         }
// //     }

// //     override fun onBind(intent: Intent?): IBinder? = null

// //     override fun onDestroy() {
// //         executor.shutdown()
// //         super.onDestroy()
// //     }
// // }



// package com.example.safeapp.services

// import android.app.Service
// import android.app.usage.UsageStatsManager
// import android.app.admin.DevicePolicyManager
// import android.content.ComponentName
// import android.content.Context
// import android.content.Intent
// import android.os.IBinder
// import android.util.Log
// import java.util.concurrent.Executors
// import java.util.concurrent.TimeUnit
// import java.lang.reflect.Method

// class AppBlockerService : Service() {
//     private val executor = Executors.newSingleThreadScheduledExecutor()
//     private lateinit var devicePolicyManager: DevicePolicyManager
//     private lateinit var adminComponent: ComponentName
//     private lateinit var prefs: AppBlockerPreferences
//     private lateinit var usageStatsManager: UsageStatsManager

//     override fun onCreate() {
//         super.onCreate()
//         devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         adminComponent = ComponentName(this, "com.example.safeapp.services.MyDeviceAdminReceiver")
//         prefs = AppBlockerPreferences(this)
//         usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
//         startBlocking()
//     }

//     private fun startBlocking() {
//         executor.scheduleAtFixedRate({
//             val blockedApps = prefs.getBlockedApps()
//             if (blockedApps.isNotEmpty()) {
//                 checkAndBlockApps(blockedApps)
//             }
//         }, 0, 3, TimeUnit.SECONDS)
//     }

//     private fun checkAndBlockApps(blockedApps: Set<String>) {
//         val endTime = System.currentTimeMillis()
//         val stats = usageStatsManager.queryUsageStats(
//             UsageStatsManager.INTERVAL_DAILY,
//             endTime - 1000 * 10,
//             endTime
//         )

//         stats?.forEach { usageStats ->
//             if (blockedApps.contains(usageStats.packageName)) {
//                 forceStopApp(usageStats.packageName)
//             }
//         }
//     }

//     private fun forceStopApp(packageName: String) {
//         try {
//             if (devicePolicyManager.isAdminActive(adminComponent)) {
//                 try {
//                     val method = DevicePolicyManager::class.java
//                         .getMethod("forceStopPackage", String::class.java)
//                     method.invoke(devicePolicyManager, packageName)
//                     Log.d("AppBlocker", "Force stopped: $packageName")
//                 } catch (e: Exception) {
//                     Log.e("AppBlocker", "Reflection failed, using kill instead", e)
//                     killBackgroundProcesses(packageName)
//                 }
//             } else {
//                 killBackgroundProcesses(packageName)
//             }
//         } catch (e: Exception) {
//             Log.e("AppBlocker", "Error stopping $packageName", e)
//         }
//     }

//     private fun killBackgroundProcesses(packageName: String) {
//         try {
//             val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
//             activityManager.killBackgroundProcesses(packageName)
//             Log.d("AppBlocker", "Killed background: $packageName")
//         } catch (e: Exception) {
//             Log.e("AppBlocker", "Error killing $packageName", e)
//         }
//     }

//     override fun onBind(intent: Intent?): IBinder? = null

//     override fun onDestroy() {
//         executor.shutdown()
//         super.onDestroy()
//     }
// }