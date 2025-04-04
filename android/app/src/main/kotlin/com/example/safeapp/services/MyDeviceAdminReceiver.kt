// package com.example.safeapp.services

// import android.app.admin.DeviceAdminReceiver
// import android.content.Context
// import android.content.Intent
// import android.util.Log
// import android.widget.Toast

// class MyDeviceAdminReceiver : DeviceAdminReceiver() {

//     companion object {
//         fun getComponentName(context: Context): ComponentName {
//             return ComponentName(context.applicationContext, MyDeviceAdminReceiver::class.java)
//         }
//     }

//     override fun onEnabled(context: Context, intent: Intent) {
//         super.onEnabled(context, intent)
//         showToast(context, "Device Admin Enabled")
//         Log.d("DeviceAdmin", "Admin enabled")
        
//         // Verify admin rights immediately
//         val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         if (!dpm.isAdminActive(getComponentName(context))) {
//             Log.e("DeviceAdmin", "Admin not active despite onEnabled callback")
//         }
//     }

//     // override fun onEnabled(context: Context, intent: Intent) {
//     //     super.onEnabled(context, intent)
//     //     Log.d("DeviceAdmin", "Device Admin Enabled")
//     //     Toast.makeText(context, "Device Admin Enabled", Toast.LENGTH_SHORT).show()
//     // }

//     override fun onDisabled(context: Context, intent: Intent) {
//         super.onDisabled(context, intent)
//         Log.d("DeviceAdmin", "Device Admin Disabled")
//         Toast.makeText(context, "Device Admin Disabled", Toast.LENGTH_SHORT).show()
//     }

//     override fun onProfileProvisioningComplete(context: Context, intent: Intent) {
//         super.onProfileProvisioningComplete(context, intent)
//         Log.d("DeviceAdmin", "Profile provisioning complete")
        
//         // Enable admin after profile provisioning
//         val component = getComponentName(context)
//         val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         dpm.setProfileEnabled(component)
//     }

//     private fun showToast(context: Context, message: String) {
//         Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
//     }
// }


// package com.example.safeapp.services

// import android.app.admin.DeviceAdminReceiver
// import android.app.admin.DevicePolicyManager
// import android.content.ComponentName
// import android.content.Context
// import android.content.Intent
// import android.util.Log
// import android.widget.Toast

// class MyDeviceAdminReceiver : DeviceAdminReceiver() {

//     companion object {
//         fun getComponentName(context: Context): ComponentName {
//             return ComponentName(context.applicationContext, MyDeviceAdminReceiver::class.java)
//         }
//     }

//     override fun onEnabled(context: Context, intent: Intent) {
//         super.onEnabled(context, intent)
//         showToast(context, "Device Admin Enabled")
//         Log.d("DeviceAdmin", "Admin enabled")
        
//         // Verify admin rights
//         val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         if (!dpm.isAdminActive(getComponentName(context))) {
//             Log.e("DeviceAdmin", "Admin not active despite onEnabled callback")
//         }
//     }

//     override fun onDisabled(context: Context, intent: Intent) {
//         super.onDisabled(context, intent)
//         showToast(context, "Device Admin Disabled")
//         Log.d("DeviceAdmin", "Admin disabled")
//     }

//     override fun onProfileProvisioningComplete(context: Context, intent: Intent) {
//         super.onProfileProvisioningComplete(context, intent)
//         Log.d("DeviceAdmin", "Profile provisioning complete")
        
//         // Enable profile after provisioning
//         val component = getComponentName(context)
//         val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
//         if (dpm.isProfileOwnerApp(context.packageName)) {
//             dpm.setProfileName(component, "SafeApp Profile")
//             Log.d("DeviceAdmin", "Profile enabled and named")
//         }
//     }

//     private fun showToast(context: Context, message: String) {
//         Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
//     }
// }



package com.example.safeapp.services

import android.app.admin.DeviceAdminReceiver
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast

class MyDeviceAdminReceiver : DeviceAdminReceiver() {

    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        showToast(context, "Device Admin Enabled")
        Log.d("DeviceAdmin", "Admin enabled")
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        showToast(context, "Device Admin Disabled")
        Log.d("DeviceAdmin", "Admin disabled")
    }

    // override fun onProfileProvisioningComplete(context: Context, intent: Intent) {
    //     val manager = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
    //     val component = ComponentName(context, MyDeviceAdminReceiver::class.java)
        
    //     // Enable required policies
    //     manager.setProfileEnabled(component)
    //     manager.setCameraDisabled(component, true)
        
    //     Log.d("DeviceAdmin", "Profile provisioning complete")
    // }

    private fun showToast(context: Context, message: String) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
    }

    companion object {
        fun getComponentName(context: Context): ComponentName {
            return ComponentName(context.applicationContext, DeviceAdminReceiver::class.java)
        }
    }
}