import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class GlobalSearchBar extends StatelessWidget {
  const GlobalSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final productProv = Provider.of<ProductProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) => productProv.search(value),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search products...',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}