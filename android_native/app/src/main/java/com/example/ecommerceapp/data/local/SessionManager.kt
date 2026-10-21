package com.example.ecommerceapp.data.local

import android.content.Context
import android.content.SharedPreferences

class SessionManager(context: Context) {

    private val prefs: SharedPreferences =
        context.getSharedPreferences("ecommerce_prefs", Context.MODE_PRIVATE)

    companion object {
        private const val KEY_TOKEN = "token"
    }

    fun saveToken(token: String) {
        prefs.edit().putString(KEY_TOKEN, token).apply()
    }

    fun getToken(): String? {
        return prefs.getString(KEY_TOKEN, null)
    }

    fun clearToken() {
        prefs.edit().remove(KEY_TOKEN).apply()
    }

    fun isAuthenticated(): Boolean {
        val token = getToken()
        return !token.isNullOrEmpty()
    }
}
