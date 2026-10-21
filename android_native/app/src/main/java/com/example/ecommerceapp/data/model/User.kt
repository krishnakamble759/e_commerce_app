package com.example.ecommerceapp.data.model

data class User(
    val username: String,
    val password: String,
    val token: String? = null
)
