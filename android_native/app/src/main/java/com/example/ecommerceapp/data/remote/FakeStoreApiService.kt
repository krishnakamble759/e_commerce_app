package com.example.ecommerceapp.data.remote

import com.example.ecommerceapp.data.model.Product
import com.example.ecommerceapp.data.remote.dto.CartRequest
import com.example.ecommerceapp.data.remote.dto.LoginRequest
import com.example.ecommerceapp.data.remote.dto.LoginResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

interface FakeStoreApiService {

    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<LoginResponse>

    @GET("products")
    suspend fun getProducts(): List<Product>

    @GET("products/categories")
    suspend fun getCategories(): List<String>

    @GET("products/category/{category}")
    suspend fun getProductsByCategory(@Path("category") category: String): List<Product>

    @POST("carts")
    suspend fun createCart(@Body request: CartRequest): Response<Any>
}
