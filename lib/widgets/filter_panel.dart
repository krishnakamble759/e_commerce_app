import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final productProv = Provider.of<ProductProvider>(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Center(
              child: Text(
                'Filter & Sorting',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),

          // ===== CATEGORY FILTERS =====
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ Updated category radio group (Flutter 3.32+)
          Column(
            children: [
              for (final category in productProv.categories)
                RadioMenuButton<String>(
                  value: category,
                  groupValue: productProv.selectedCategory,
                  onChanged: (value) {
                    if (value != null) {
                      productProv.filterByCategory(value);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(category),
                ),
            ],
          ),

          const Divider(),

          // ===== SORTING OPTIONS =====
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Sort By',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ Sorting radios
          Column(
            children: [
              RadioMenuButton<String>(
                value: 'Price: Low to High',
                groupValue: productProv.sortOrder,
                onChanged: (value) {
                  if (value != null) {
                    productProv.sortProducts(value);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Price: Low to High'),
              ),
              RadioMenuButton<String>(
                value: 'Price: High to Low',
                groupValue: productProv.sortOrder,
                onChanged: (value) {
                  if (value != null) {
                    productProv.sortProducts(value);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Price: High to Low'),
              ),
              RadioMenuButton<String>(
                value: 'A-Z',
                groupValue: productProv.sortOrder,
                onChanged: (value) {
                  if (value != null) {
                    productProv.sortProducts(value);
                    Navigator.pop(context);
                  }
                },
                child: const Text('A-Z'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
