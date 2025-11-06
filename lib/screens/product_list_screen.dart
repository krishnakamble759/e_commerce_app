// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    Provider.of<CartProvider>(context, listen: false).loadCartFromDb();
  }

  @override
  Widget build(BuildContext context) {
    final productProv = Provider.of<ProductProvider>(context);
    final cartProv = Provider.of<CartProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProv.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: productProv.search,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: Text('Filters & Sorting', style: TextStyle(fontSize: 18)),
            ),
            Expanded(
              child: ListView(
                children: [
                  const ListTile(title: Text('Categories')),
                  ...productProv.categories.map((c) {
                    return RadioListTile<String>(
                      title: Text(c),
                      value: c,
                      groupValue: productProv.selectedCategory,
                      onChanged: (v) => productProv.filterByCategory(v!),
                    );
                  }),
                  const Divider(),
                  const ListTile(title: Text('Sort By')),
                  ...[
                    'None',
                    'Price: Low to High',
                    'Price: High to Low',
                    'A-Z'
                  ].map((s) {
                    return RadioListTile<String>(
                      title: Text(s),
                      value: s,
                      groupValue: productProv.sortOrder,
                      onChanged: (v) => productProv.sortProducts(v!),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      body: productProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: productProv.products.length,
              itemBuilder: (context, i) {
                final Product p = productProv.products[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: p),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Image.network(p.image, fit: BoxFit.contain)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            p.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('\$${p.price.toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () => cartProv.addToCart(p),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
