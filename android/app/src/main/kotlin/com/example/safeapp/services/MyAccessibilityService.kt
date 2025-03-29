package com.example.safeapp.services

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.view.accessibility.AccessibilityEvent
import android.util.Log

class MyAccessibilityService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        val packageName = event.packageName?.toString() ?: return
        val monitoredApps = listOf("com.whatsapp", "com.example.safeapp")

        // if (packageName !in monitoredApps) {
        //     return // Ignore all other apps
        // }

        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                Log.d("MyAccessibilityService", "App Opened: $packageName")
            }
            AccessibilityEvent.TYPE_VIEW_CLICKED -> {
                Log.d("MyAccessibilityService", "User clicked in: $packageName")
            }
        }
    }


    override fun onInterrupt() {
        Log.d("AccessibilityService", "Service Interrupted")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        val info = AccessibilityServiceInfo()
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        info.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
        serviceInfo = info
        Log.d("AccessibilityService", "Service Connected")
    }

    private fun isBankingApp(packageName: String): Boolean {
        val bankingApps = listOf("com.example.bankapp", "com.google.android.apps.walletnfcrel") // Add banking/payment app package names
        return bankingApps.contains(packageName)
    }
}
