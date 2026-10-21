package com.example.ecommerceapp

import android.app.Application
import com.example.ecommerceapp.data.local.CartDatabase
import com.example.ecommerceapp.data.local.SessionManager
import com.example.ecommerceapp.data.remote.RetrofitClient
import com.example.ecommerceapp.data.repository.AuthRepository
import com.example.ecommerceapp.data.repository.CartRepository
import com.example.ecommerceapp.data.repository.ProductRepository

class ECommerceApplication : Application() {

    lateinit var sessionManager: SessionManager
        private set

    lateinit var cartDatabase: CartDatabase
        private set

    lateinit var authRepository: AuthRepository
        private set

    lateinit var productRepository: ProductRepository
        private set

    lateinit var cartRepository: CartRepository
        private set

    override fun onCreate() {
        super.onCreate()

        sessionManager = SessionManager(this)
        cartDatabase = CartDatabase.getDatabase(this)

        val apiService = RetrofitClient.apiService
        authRepository = AuthRepository(apiService, sessionManager)
        productRepository = ProductRepository(apiService)
        cartRepository = CartRepository(cartDatabase.cartDao(), apiService)
    }
}
