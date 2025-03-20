package com.example.safeapp.services

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.view.accessibility.AccessibilityEvent
import android.util.Log

class MyAccessibilityService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event != null && event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: return
            Log.d("AccessibilityService", "Foreground App: $packageName")

            // Here, you can check if the app is a banking/payment app and take action
            if (isBankingApp(packageName)) {
                Log.d("AccessibilityService", "Banking app detected: $packageName")
                // You can implement screen recording prevention here
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
