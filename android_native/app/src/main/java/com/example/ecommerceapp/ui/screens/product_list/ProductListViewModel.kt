package com.example.ecommerceapp.ui.screens.product_list

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.example.ecommerceapp.data.model.Product
import com.example.ecommerceapp.data.repository.AuthRepository
import com.example.ecommerceapp.data.repository.CartRepository
import com.example.ecommerceapp.data.repository.ProductRepository
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

data class ProductListUiState(
    val allProducts: List<Product> = emptyList(),
    val filteredProducts: List<Product> = emptyList(),
    val categories: List<String> = listOf("All"),
    val selectedCategory: String = "All",
    val searchQuery: String = "",
    val sortOrder: String = "None",
    val isLoading: Boolean = false,
    val cartCount: Int = 0
)

class ProductListViewModel(
    private val productRepository: ProductRepository,
    private val cartRepository: CartRepository,
    private val authRepository: AuthRepository
) : ViewModel() {

    val sortOptions = listOf("None", "Price: Low to High", "Price: High to Low", "A-Z")

    private val _uiState = MutableStateFlow(ProductListUiState())
    val uiState: StateFlow<ProductListUiState> = _uiState.asStateFlow()

    private val _userMessage = MutableSharedFlow<String>()
    val userMessage: SharedFlow<String> = _userMessage.asSharedFlow()

    init {
        fetchProducts()
        observeCart()
    }

    private fun observeCart() {
        viewModelScope.launch {
            cartRepository.getCartItemsFlow().collect { items ->
                val totalItems = items.sumOf { it.quantity }
                _uiState.update { it.copy(cartCount = totalItems) }
            }
        }
    }

    fun fetchProducts() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }

            val productsResult = productRepository.getProducts()
            val categoriesResult = productRepository.getCategories()

            val products = productsResult.getOrDefault(emptyList())
            val categories = mutableListOf("All").apply {
                addAll(categoriesResult.getOrDefault(emptyList()))
            }

            _uiState.update {
                it.copy(
                    allProducts = products,
                    categories = categories,
                    isLoading = false
                )
            }
            applyFilters()
        }
    }

    fun filterByCategory(category: String) {
        _uiState.update { it.copy(selectedCategory = category) }
        applyFilters()
    }

    fun search(query: String) {
        _uiState.update { it.copy(searchQuery = query) }
        applyFilters()
    }

    fun sortProducts(sort: String) {
        _uiState.update { it.copy(sortOrder = sort) }
        applyFilters()
    }

    private fun applyFilters() {
        val state = _uiState.value
        var temp = state.allProducts

        if (!state.selectedCategory.equals("All", ignoreCase = true)) {
            temp = temp.filter { it.category.equals(state.selectedCategory, ignoreCase = true) }
        }

        if (state.searchQuery.isNotBlank()) {
            val q = state.searchQuery.trim().lowercase()
            temp = temp.filter {
                it.title.lowercase().contains(q) || it.description.lowercase().contains(q)
            }
        }

        temp = when (state.sortOrder) {
            "Price: Low to High" -> temp.sortedBy { it.price }
            "Price: High to Low" -> temp.sortedByDescending { it.price }
            "A-Z" -> temp.sortedBy { it.title.lowercase() }
            else -> temp
        }

        _uiState.update { it.copy(filteredProducts = temp) }
    }

    fun addToCart(product: Product) {
        viewModelScope.launch {
            cartRepository.addToCart(product)
            _userMessage.emit("${product.title} added to cart")
        }
    }

    fun logout() {
        authRepository.logout()
    }

    fun getProductById(id: Int): Product? {
        return _uiState.value.allProducts.find { it.id == id }
    }

    class Factory(
        private val productRepository: ProductRepository,
        private val cartRepository: CartRepository,
        private val authRepository: AuthRepository
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return ProductListViewModel(productRepository, cartRepository, authRepository) as T
        }
    }
}
