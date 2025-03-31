package com.example.safeapp.services

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.view.accessibility.AccessibilityEvent
import android.util.Log
import android.view.WindowManager.LayoutParams
import android.view.WindowManager
import android.view.WindowManager.LayoutParams.*
import android.graphics.PixelFormat
import android.view.View
import android.content.Context
import android.widget.FrameLayout
import android.widget.Toast
import android.content.Intent
import android.net.Uri
import android.app.AlertDialog
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityNodeInfo
import android.provider.Settings

class MyAccessibilityService : AccessibilityService() {

    // private var overlayView: View? = null

    // private val messagesApp = "com.samsung.android.messaging" // Messages App Package Name
    // private val unsafeDomains = listOf("phishing.com", "scam-site.net", "fakebank.io") // Unsafe links


    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        val packageName = event.packageName?.toString() ?: return
        // val monitoredApps = listOf("com.whatsapp", "com.example.safeapp")

        // if (packageName !in monitoredApps) {
        //     return // Ignore all other apps
        // }

        // Check if user is inside the Messages app
        // if (packageName == messagesApp && event.eventType == AccessibilityEvent.TYPE_VIEW_CLICKED) {
        //     val text = event.text?.joinToString(" ") ?: return
        //     Log.d("AccessibilityService", "Clicked Text: $text")

        //     // Extract URL from the clicked text
        //     val extractedUrl = extractUrl(text)
        //     if (extractedUrl != null) {
        //         Log.d("AccessibilityService", "Extracted URL: $extractedUrl")

        //         // Check if the URL is unsafe
        //         if (isUnsafeLink(extractedUrl)) {
        //             showWarningDialog(extractedUrl)
        //         }
        //     }
        // }

        // if (packageName == messagesApp) {
        //     // val text = event.text?.joinToString(" ") ?: return
        //     val text = event.source?.text?.toString() ?: return

        //     // val text = event.text
        //     Log.d("AccessibilityService", "Window 1234 message Changed, New Text: $text")

        //     // val extractedUrl = extractUrl(text)
        //     // if (extractedUrl != null && isUnsafeLink(extractedUrl)) {
        //     //     showWarningDialog(extractedUrl)
        //     // }

        //     // Traverse the view hierarchy to find links
        //     val rootNode = rootInActiveWindow
        //     findLinks(rootNode)
        // }


        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                Log.d("MyAccessibilityService", "App Opened: $packageName")
            }
            AccessibilityEvent.TYPE_VIEW_CLICKED -> {
                Log.d("MyAccessibilityService", "User clicked in: $packageName")
            }
            AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED -> {
                Log.d("MyAccessibilityService", "Window content Changed: $packageName")
            }
            AccessibilityEvent.TYPE_VIEW_SELECTED -> {
                Log.d("MyAccessibilityService", "type view selected: $packageName")
            }
            AccessibilityEvent.TYPE_WINDOWS_CHANGED -> {
                Log.d("MyAccessibilityService", "type Windows Changed: $packageName")
            }

        }
    }

    override fun onInterrupt() {
        Log.d("AccessibilityService", "Service Interrupted")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        val info = AccessibilityServiceInfo()
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or AccessibilityEvent.TYPE_VIEW_CLICKED or AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED or AccessibilityEvent.TYPE_VIEW_SELECTED or AccessibilityEvent.TYPE_WINDOWS_CHANGED
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        info.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS or AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS
        serviceInfo = info

        // Check and request overlay permission if not granted
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
        }

        Log.d("AccessibilityService", "Service Connected")
    }

    // private fun findLinks(node: AccessibilityNodeInfo?) {
    //     if (node == null) return

    //     if (node.text != null) {
    //         val text = node.text.toString()
    //         Log.d("AccessibilityService", "Found text: $text")
    //         val extractedUrl = extractUrl(text)
    //         if (extractedUrl != null && !isUnsafeLink(extractedUrl)) {
    //             showWarningDialog(extractedUrl)
    //         }
    //     }

    //     for (i in 0 until node.childCount) {
    //         findLinks(node.getChild(i))
    //     }
    // }


    // private fun isBankingApp(packageName: String): Boolean {
    //     val bankingApps = listOf("com.example.bankapp", "com.google.android.apps.walletnfcrel") // Add banking/payment app package names
    //     return bankingApps.contains(packageName)
    // }

    // private fun extractUrl(text: String): String? {
    //     val regex = "(https?://[a-zA-Z0-9./?=_-]+)".toRegex()
    //     val matchResult = regex.find(text)
    //     return matchResult?.value
    // }

    // private fun isUnsafeLink(url: String): Boolean {
    //     return unsafeDomains.any { domain -> url.contains(domain, ignoreCase = true) }
    // }

    private fun showWarningDialog(url: String) {
        Handler(Looper.getMainLooper()).post {
            val builder = AlertDialog.Builder(this@MyAccessibilityService)
            builder.setTitle("Warning: Unsafe Link Detected!")
            builder.setMessage("You are trying to open an unauthorized link:\n$url\n\nIt may be dangerous. Do you still want to continue?")
            builder.setPositiveButton("Ignore") { dialog, _ ->
                dialog.dismiss()
            }
            builder.setNegativeButton("Cancel") { dialog, _ ->
                dialog.dismiss()
            }

            val dialog = builder.create()
            dialog.window?.setType(WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY) // Set overlay window type
            dialog.show()
        }
    }


}
