import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$baseUrl/products');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<String>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/products/categories');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return List<String>.from(json.decode(res.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/products/category/$category');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load category products');
    }
  }

  Future<void> createCart(Map<String, dynamic> cartData) async {
    final url = Uri.parse('$baseUrl/carts');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartData),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create cart');
    }
  }
}
