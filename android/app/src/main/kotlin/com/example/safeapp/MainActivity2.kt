// package com.example.safeapp

// import android.app.ActivityManager
// import android.app.AppOpsManager
// import android.app.admin.DevicePolicyManager
// import android.content.ComponentName
// import android.content.Context
// import android.content.Intent
// import android.os.Bundle
// import android.provider.Settings
// import android.util.Log
// import android.view.WindowManager
// import androidx.annotation.NonNull
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import com.example.safeapp.services.MyDeviceAdminReceiver

// class MainActivity : FlutterActivity() {

//     private val CHANNEL = "device_admin_channel"
//     private lateinit var devicePolicyManager: DevicePolicyManager
//     private lateinit var adminComponent: ComponentName

//     override fun onCreate(savedInstanceState: Bundle?) {
//         super.onCreate(savedInstanceState)
//         initializeScreenProtection()
//         checkPermissions()
//     }

//      override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
        
//         devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         adminComponent = MyDeviceAdminReceiver.getComponentName(this)

//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             when (call.method) {
//                 "requestDeviceAdmin" -> requestAdmin(result)
//                 "blockApplication" -> {
//                     val packageName = call.argument<String>("packageName")
//                     if (packageName != null) {
//                         blockApplication(packageName, result)
//                     } else {
//                         result.error("INVALID_ARG", "Package name required", null)
//                     }
//                 }
//                 "isAdminActive" -> result.success(isAdminActive())
//                 else -> result.notImplemented()
//             }
//         }
//     }

//     private fun isAdminActive(): Boolean {
//         return devicePolicyManager.isAdminActive(adminComponent)
//     }

//      private fun requestAdmin(result: MethodChannel.Result) {
//         try {
//             val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
//                 putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent)
//                 putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, 
//                     "Required for security features")
//             }
//             startActivity(intent)
//             result.success(true)
//         } catch (e: Exception) {
//             result.error("ADMIN_ERROR", "Failed to request admin", null)
//         }
//     }

//     private fun blockApplication(packageName: String, result: MethodChannel.Result) {
//         try {
//             if (!isAdminActive()) {
//                 result.error("ADMIN_REQUIRED", "Admin rights not active", null)
//                 return
//             }

//             // Hide application
//             devicePolicyManager.setApplicationHidden(adminComponent, packageName, true)
            
//             // Force stop application
//             (getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager)
//                 .killBackgroundProcesses(packageName)
            
//             result.success(true)
//         } catch (e: SecurityException) {
//             result.error("SECURITY_ERROR", "Permission denied", null)
//         } catch (e: Exception) {
//             result.error("BLOCK_ERROR", "Failed to block app", null)
//         }
//     }

//     private fun initializeScreenProtection() {
//         window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
//     }

//     private fun checkPermissions() {
//         logPermissionStatus("Accessibility", isAccessibilityEnabled())
//         logPermissionStatus("Usage Stats", isUsageStatsEnabled())
//         logPermissionStatus("Device Admin", isDeviceAdminEnabled())
//     }

//     private fun logPermissionStatus(permissionName: String, enabled: Boolean) {
//         Log.d("Permissions", "$permissionName Service ${if (enabled) "Enabled" else "Disabled"}")
//     }

//     private fun isAccessibilityEnabled(): Boolean {
//         val serviceId = "${packageName}/.services.MyAccessibilityService"
//         return Settings.Secure.getString(contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
//             ?.contains(serviceId) == true
//     }

//     private fun isUsageStatsEnabled(): Boolean {
//         val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
//         return appOps.checkOpNoThrow(
//             AppOpsManager.OPSTR_GET_USAGE_STATS,
//             android.os.Process.myUid(),
//             packageName
//         ) == AppOpsManager.MODE_ALLOWED
//     }

//     private fun isDeviceAdminEnabled(): Boolean {
//         return devicePolicyManager.isAdminActive(adminComponent)
//     }

//     private fun setupDeviceAdminServices() {
//         devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         adminComponent = ComponentName(this, MyDeviceAdminReceiver::class.java)
//     }

//     private fun configureMethodChannels(flutterEngine: FlutterEngine) {
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
//             setMethodCallHandler { call, result ->
//                 when {
//                     call.method.startsWith("admin:") -> handleAdminOperations(call, result)
//                     call.method == "requestDeviceAdmin" -> handleAdminRequest(result)
//                     call.method == "isAdminActive" -> result.success(isDeviceAdminEnabled())
//                     call.method == "isProfileOwner" -> result.success(isProfileOwner())
//                     else -> result.notImplemented()
//                 }
//             }
//         }
//     }

//     private fun isProfileOwner(): Boolean {
//         return devicePolicyManager.isProfileOwnerApp(packageName)
//     }

//     private fun handleAdminOperations(call: MethodCall, result: MethodChannel.Result) {
//         when (call.method) {
//             "admin:blockApplication" -> handleBlockOperation(call, result)
//             else -> result.notImplemented()
//         }
//     }

//     private fun handleBlockOperation(call: MethodCall, result: MethodChannel.Result) {
//         val packageName = call.argument<String>("targetPackage")?.takeIf { it.isNotEmpty() }
//             ?: run {
//                 result.error("INVALID_INPUT", "Package name cannot be empty", null)
//                 return
//             }

//         try {
//             if (!isDeviceAdminEnabled()) {
//                 result.error("ADMIN_REQUIRED", "Device administrator privileges not granted", null)
//                 return
//             }

//             // First try to hide the app
//             devicePolicyManager.setApplicationHidden(adminComponent, packageName, true)
            
//             // Then try to stop the app
//             (getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager)
//                 .killBackgroundProcesses(packageName)
            
//             result.success(mapOf(
//                 "success" to true,
//                 "message" to "Application $packageName blocked"
//             ))
//         } catch (e: SecurityException) {
//             result.error("SECURITY_VIOLATION", "Permission denied: ${e.message}", null)
//         } catch (e: Exception) {
//             result.error("OPERATION_FAILED", "Failed to block application: ${e.message}", null)
//         }
//     }

//     private fun handleAdminRequest(result: MethodChannel.Result) {
//         try {
//             Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
//                 putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent)
//                 putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, 
//                     "Required for application management features")
//                 startActivity(this)
//                 result.success(mapOf(
//                     "success" to true,
//                     "message" to "Admin request initiated"
//                 ))
//             }
//         } catch (e: Exception) {
//             result.error("REQUEST_FAILED", "Failed to start admin activation: ${e.message}", null)
//         }
//     }
// }