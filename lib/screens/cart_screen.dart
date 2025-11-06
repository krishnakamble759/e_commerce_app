import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => cartProv.clearCart(),
          ),
        ],
      ),
      body: cartProv.items.isEmpty
          ? const Center(child:Text('Your Cart is Empty'))
          :Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProv.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProv.items[index];
                    return ListTile(
                      leading: Image.network(item.product.image, height:50, width:50),
                      title: Text(item.product.title, maxLines: 2),
                      subtitle: Text('Quantity: ${item.quantity} . \$${item.totalPrice.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize:MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => cartProv.decreaseQuantity(item.product),
                            icon: const Icon(Icons.remove)),
                          IconButton(
                            onPressed: () => cartProv.increaseQuantity(item.product),
                            icon: const Icon(Icons.add)),
                          IconButton(
                            onPressed: () => cartProv.removeFromCart(item.product),
                            icon: const Icon(Icons.delete)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Total: \$${cartProv.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text('Proceed to Checkout'),
                      onPressed:() {
                        Navigator.pushNamed(context, '/checkout');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}