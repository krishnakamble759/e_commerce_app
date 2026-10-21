package com.example.ecommerceapp.data.repository

import com.example.ecommerceapp.data.local.SessionManager
import com.example.ecommerceapp.data.remote.FakeStoreApiService
import com.example.ecommerceapp.data.remote.dto.LoginRequest

class AuthRepository(
    private val apiService: FakeStoreApiService,
    private val sessionManager: SessionManager
) {

    suspend fun login(username: String, password: String): Result<String> {
        return try {
            val response = apiService.login(LoginRequest(username.trim(), password.trim()))
            if (response.isSuccessful && response.body()?.token != null) {
                val token = response.body()!!.token!!
                sessionManager.saveToken(token)
                Result.success(token)
            } else {
                Result.failure(Exception("Login failed. Please check your credentials."))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    fun logout() {
        sessionManager.clearToken()
    }

    fun getToken(): String? {
        return sessionManager.getToken()
    }

    fun isLoggedIn(): Boolean {
        return sessionManager.isAuthenticated()
    }
}
