package com.example.ecommerceapp.ui.navigation

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.example.ecommerceapp.data.repository.AuthRepository
import com.example.ecommerceapp.data.repository.CartRepository
import com.example.ecommerceapp.data.repository.ProductRepository
import com.example.ecommerceapp.ui.screens.cart.CartScreen
import com.example.ecommerceapp.ui.screens.cart.CartViewModel
import com.example.ecommerceapp.ui.screens.checkout.CheckoutScreen
import com.example.ecommerceapp.ui.screens.checkout.CheckoutViewModel
import com.example.ecommerceapp.ui.screens.login.LoginScreen
import com.example.ecommerceapp.ui.screens.login.LoginViewModel
import com.example.ecommerceapp.ui.screens.product_detail.ProductDetailScreen
import com.example.ecommerceapp.ui.screens.product_list.ProductListScreen
import com.example.ecommerceapp.ui.screens.product_list.ProductListViewModel

@Composable
fun AppNavGraph(
    navController: NavHostController,
    authRepository: AuthRepository,
    productRepository: ProductRepository,
    cartRepository: CartRepository
) {
    val startDestination = if (authRepository.isLoggedIn()) {
        Screen.Products.route
    } else {
        Screen.Login.route
    }

    // Shared ProductListViewModel so that product detail can lookup products directly
    val productListViewModel: ProductListViewModel = viewModel(
        factory = ProductListViewModel.Factory(productRepository, cartRepository, authRepository)
    )

    NavHost(
        navController = navController,
        startDestination = startDestination
    ) {
        composable(Screen.Login.route) {
            val loginViewModel: LoginViewModel = viewModel(
                factory = LoginViewModel.Factory(authRepository)
            )
            LoginScreen(
                viewModel = loginViewModel,
                onLoginSuccess = {
                    navController.navigate(Screen.Products.route) {
                        popUpTo(Screen.Login.route) { inclusive = true }
                    }
                }
            )
        }

        composable(Screen.Products.route) {
            ProductListScreen(
                viewModel = productListViewModel,
                onProductClick = { product ->
                    navController.navigate(Screen.ProductDetail.createRoute(product.id))
                },
                onCartClick = {
                    navController.navigate(Screen.Cart.route)
                },
                onLogoutClick = {
                    navController.navigate(Screen.Login.route) {
                        popUpTo(Screen.Products.route) { inclusive = true }
                    }
                }
            )
        }

        composable(
            route = Screen.ProductDetail.route,
            arguments = listOf(navArgument("productId") { type = NavType.IntType })
        ) { backStackEntry ->
            val productId = backStackEntry.arguments?.getInt("productId") ?: 0
            val product = productListViewModel.getProductById(productId)

            ProductDetailScreen(
                product = product,
                onBackClick = { navController.popBackStack() },
                onAddToCart = { p -> productListViewModel.addToCart(p) }
            )
        }

        composable(Screen.Cart.route) {
            val cartViewModel: CartViewModel = viewModel(
                factory = CartViewModel.Factory(cartRepository)
            )
            CartScreen(
                viewModel = cartViewModel,
                onBackClick = { navController.popBackStack() },
                onCheckoutClick = {
                    navController.navigate(Screen.Checkout.route)
                }
            )
        }

        composable(Screen.Checkout.route) {
            val checkoutViewModel: CheckoutViewModel = viewModel(
                factory = CheckoutViewModel.Factory(cartRepository)
            )
            CheckoutScreen(
                viewModel = checkoutViewModel,
                onBackClick = { navController.popBackStack() },
                onOrderPlaced = {
                    navController.popBackStack(Screen.Products.route, inclusive = false)
                }
            )
        }
    }
}
