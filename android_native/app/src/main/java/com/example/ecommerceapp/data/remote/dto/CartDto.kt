package com.example.ecommerceapp.data.remote.dto

import com.google.gson.annotations.SerializedName

data class CartRequest(
    @SerializedName("userId")
    val userId: Int,
    @SerializedName("date")
    val date: String,
    @SerializedName("products")
    val products: List<CartProductRequest>
)

data class CartProductRequest(
    @SerializedName("productId")
    val productId: Int,
    @SerializedName("quantity")
    val quantity: Int
)
