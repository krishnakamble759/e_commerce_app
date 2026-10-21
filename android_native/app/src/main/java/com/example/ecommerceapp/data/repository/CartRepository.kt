package com.example.ecommerceapp.data.repository

import com.example.ecommerceapp.data.local.CartDao
import com.example.ecommerceapp.data.local.CartEntity
import com.example.ecommerceapp.data.model.CartItem
import com.example.ecommerceapp.data.model.Product
import com.example.ecommerceapp.data.remote.FakeStoreApiService
import com.example.ecommerceapp.data.remote.dto.CartProductRequest
import com.example.ecommerceapp.data.remote.dto.CartRequest
import com.google.gson.Gson
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class CartRepository(
    private val cartDao: CartDao,
    private val apiService: FakeStoreApiService
) {
    private val gson = Gson()

    fun getCartItemsFlow(): Flow<List<CartItem>> {
        return cartDao.getCartItemsFlow().map { entities ->
            entities.map { it.toCartItem() }
        }
    }

    suspend fun getCartItems(): List<CartItem> {
        return cartDao.getCartItems().map { it.toCartItem() }
    }

    suspend fun addToCart(product: Product) {
        val existing = cartDao.getCartItemByProductId(product.id)
        if (existing != null) {
            val updated = existing.copy(quantity = existing.quantity + 1)
            cartDao.updateCartItem(updated)
        } else {
            val newEntity = CartEntity(
                productId = product.id,
                title = product.title,
                price = product.price,
                quantity = 1,
                image = product.image
            )
            cartDao.insertCartItem(newEntity)
        }
    }

    suspend fun removeFromCart(productId: Int) {
        cartDao.deleteCartItem(productId)
    }

    suspend fun increaseQuantity(productId: Int) {
        val existing = cartDao.getCartItemByProductId(productId) ?: return
        val updated = existing.copy(quantity = existing.quantity + 1)
        cartDao.updateCartItem(updated)
    }

    suspend fun decreaseQuantity(productId: Int) {
        val existing = cartDao.getCartItemByProductId(productId) ?: return
        if (existing.quantity <= 1) {
            cartDao.deleteCartItem(productId)
        } else {
            val updated = existing.copy(quantity = existing.quantity - 1)
            cartDao.updateCartItem(updated)
        }
    }

    suspend fun clearCart() {
        cartDao.clearCart()
    }

    suspend fun exportCartToJson(): String {
        val items = getCartItems()
        return gson.toJson(items)
    }

    suspend fun submitCartOrder(userId: Int, date: String, items: List<CartItem>): Result<Unit> {
        return try {
            val request = CartRequest(
                userId = userId,
                date = date,
                products = items.map {
                    CartProductRequest(
                        productId = it.product.id,
                        quantity = it.quantity
                    )
                }
            )
            val response = apiService.createCart(request)
            if (response.isSuccessful) {
                clearCart()
                Result.success(Unit)
            } else {
                Result.failure(Exception("Failed to submit cart: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
