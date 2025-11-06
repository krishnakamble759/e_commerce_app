import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/db_service.dart';

class CartProvider extends ChangeNotifier {
  final DbService _db = DbService();
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  double get totalPrice {
    double total = 0.0;
    for (final item in _items.values) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  Future<void> loadCartFromDb() async {
    final saved = await _db.getCartItems();
    _items.clear();
    for (var item in saved) {
      _items[item.product.id] = item;
    }
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    await _db.insertCartItem(_items[product.id]!);
    notifyListeners();
  }

  Future<void> removeFromCart(Product product) async {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
      await _db.deleteCartItem(product.id);
      notifyListeners();
    }
  }

  Future<void> decreaseQuantity(Product product) async {
    if (_items.containsKey(product.id)) {
      final item = _items[product.id]!;
      item.quantity--;
      if (item.quantity <= 0) {
        await removeFromCart(product);
      } else {
        await _db.insertCartItem(item);
      }
      notifyListeners();
    }
  }

  Future<void> increaseQuantity(Product product) async {
    if (_items.containsKey(product.id)) {
      final item = _items[product.id]!;
      item.quantity++;
      await _db.insertCartItem(item);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _db.clearCart();
    notifyListeners();
  }

  Future<String> exportCartAsJson() async {
    return await _db.exportCartToJson();
  }
}
