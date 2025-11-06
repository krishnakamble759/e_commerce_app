import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_services.dart';

class ProductProvider extends ChangeNotifier{
  final ApiService _apiservice = ApiService();

  List<Product> _allProducts =[];
  List<Product> _filteredProducts =[];
  List<String> _categories =[];

  bool _loading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortOrder = 'None';

  List<Product> get products => _filteredProducts;
  List<String> get categories => _categories;
  bool get isLoading => _loading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortOrder => _sortOrder;

  Future<void> fetchProducts() async {
    _loading =true;
    notifyListeners();

    try{
      _allProducts = await _apiservice.fetchProducts();
      _filteredProducts = _allProducts;
      _categories = ['All'];
      _categories.addAll(await _apiservice.fetchCategories());
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }

    _loading = false;
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void sortProducts(String option) {
    _sortOrder = option;
    _applyFilters();
  }

  void _applyFilters() {
    List<Product> temp = List.from(_allProducts);

    if (_selectedCategory != 'All') {
      temp = temp.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      temp = temp
      .where ((p) =>
      p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.description.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();
    }

    if(_sortOrder == 'Price: Low to High') {
      temp.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOrder == 'Price: High to Low') {
      temp.sort((a, b) => b.price.compareTo(a.price));
    }else if (_sortOrder == 'A-Z') {
      temp.sort((a, b) => a.title.compareTo(b.title));
    }

    _filteredProducts = temp;
    notifyListeners();
  }
}