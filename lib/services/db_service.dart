import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class DbService{
  static final DbService _instance = DbService._internal();
  factory DbService()=> _instance;
  DbService._internal();

  Database? _db;

  Future<Database> get database async {
    if(_db !=null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cart.db');

    return await openDatabase(
      path,
      version:1,
      onCreate:(db, version) async {
        await db.execute('''
        CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREAMENT,
        productId INTEGER,
        title TEXT,
        price REAL,
        quantity INTEGER,
        image TEXT
        )
      ''');
      },
    );
  }

  //add or update cart
  Future<void> insertCartItem(CartItem item) async {
    final db = await database;

    final existing = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs : [item.product.id],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'cart',
        {
          'quantity': item.quantity,
        },
        where: 'productId = ?',
        whereArgs: [item.product.id],
      );
    } else {
      await db.insert('cart', {
        'productId': item.product.id,
        'title': item.product.title,
        'price': item.product.price,
        'quantity': item.quantity,
        'image': item.product.image,
      });
    }
  }

  // Get all cart items
  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final maps = await db.query('cart');

    return maps.map((m) {
      final product = Product(
        id: m['productId'] as int,
        title: m['title'] as String,
        price: m['price'] as double,
        description: '',
        category: '',
        image: m['image'] as String,
      );
      return CartItem(product: product, quantity: m['quantity'] as int);
    }).toList();
  }

  /// Delete cart item
  Future<void> deleteCartItem(int productId) async {
    final db = await database;
    await db.delete('cart', where: 'productId = ?', whereArgs: [productId]);
  }

  /// Clear all cart
  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  /// Export cart as JSON dump
  Future<String> exportCartToJson() async {
    final items = await getCartItems();
    final List<Map<String, dynamic>> jsonData = items.map((e) => e.toJson()).toList();
    return jsonEncode(jsonData);
  }
}