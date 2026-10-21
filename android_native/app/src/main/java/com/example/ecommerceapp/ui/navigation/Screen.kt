package com.example.ecommerceapp.ui.navigation

sealed class Screen(val route: String) {
    object Login : Screen("login")
    object Products : Screen("products")
    object ProductDetail : Screen("product_detail/{productId}") {
        fun createRoute(productId: Int) = "product_detail/$productId"
    }
    object Cart : Screen("cart")
    object Checkout : Screen("checkout")
}
