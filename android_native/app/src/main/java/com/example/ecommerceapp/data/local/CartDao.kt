package com.example.ecommerceapp.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface CartDao {

    @Query("SELECT * FROM cart")
    fun getCartItemsFlow(): Flow<List<CartEntity>>

    @Query("SELECT * FROM cart")
    suspend fun getCartItems(): List<CartEntity>

    @Query("SELECT * FROM cart WHERE productId = :productId LIMIT 1")
    suspend fun getCartItemByProductId(productId: Int): CartEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCartItem(entity: CartEntity): Long

    @Update
    suspend fun updateCartItem(entity: CartEntity)

    @Query("DELETE FROM cart WHERE productId = :productId")
    suspend fun deleteCartItem(productId: Int)

    @Query("DELETE FROM cart")
    suspend fun clearCart()
}
