package com.example.ecommerceapp.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.example.ecommerceapp.data.model.CartItem
import com.example.ecommerceapp.data.model.Product

@Entity(tableName = "cart")
data class CartEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val productId: Int,
    val title: String,
    val price: Double,
    val quantity: Int,
    val image: String
) {
    fun toCartItem(): CartItem {
        return CartItem(
            product = Product(
                id = productId,
                title = title,
                price = price,
                description = "",
                category = "",
                image = image
            ),
            quantity = quantity
        )
    }

    companion object {
        fun fromCartItem(item: CartItem, existingId: Long = 0): CartEntity {
            return CartEntity(
                id = existingId,
                productId = item.product.id,
                title = item.product.title,
                price = item.product.price,
                quantity = item.quantity,
                image = item.product.image
            )
        }
    }
}
