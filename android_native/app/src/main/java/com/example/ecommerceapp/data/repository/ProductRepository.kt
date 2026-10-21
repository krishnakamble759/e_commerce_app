package com.example.ecommerceapp.data.repository

import com.example.ecommerceapp.data.model.Product
import com.example.ecommerceapp.data.remote.FakeStoreApiService

class ProductRepository(
    private val apiService: FakeStoreApiService
) {

    suspend fun getProducts(): Result<List<Product>> {
        return try {
            val list = apiService.getProducts()
            Result.success(list)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun getCategories(): Result<List<String>> {
        return try {
            val categories = apiService.getCategories()
            Result.success(categories)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun getProductsByCategory(category: String): Result<List<Product>> {
        return try {
            val list = apiService.getProductsByCategory(category)
            Result.success(list)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
