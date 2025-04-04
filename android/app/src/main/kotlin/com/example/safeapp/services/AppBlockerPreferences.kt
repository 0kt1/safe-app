package com.example.safeapp.services

import android.content.Context
import android.content.SharedPreferences

class AppBlockerPreferences(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("app_blocker_prefs", Context.MODE_PRIVATE)

    fun getBlockedApps(): Set<String> {
        return prefs.getStringSet("blocked_apps", emptySet()) ?: emptySet()
    }

    fun setBlockedApps(apps: Set<String>) {
        prefs.edit().putStringSet("blocked_apps", apps).apply()
    }
}