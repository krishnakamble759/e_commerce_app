import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
class ProductDetailScreen extends StatelessWidget{
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context, listen:false);

    return Scaffold(
      appBar:AppBar(title:Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(product.image, height:250),
            const SizedBox(height: 16),
            Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('\$${product.price}', style: const TextStyle(fontSize:18, color: Colors.teal)),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'),
              onPressed: () {
                cartProv.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added to cart'),
                    duration: Duration(seconds: 2),)
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}