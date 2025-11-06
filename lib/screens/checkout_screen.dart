import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_services.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _submitOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    // ✅ Capture providers outside async gap
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    final apiService = ApiService();

    setState(() => _loading = true);

    final payload = {
      "userId": 1,
      "date": DateTime.now().toIso8601String(),
      "products": cartProv.items
          .map((e) => {
                "productId": e.product.id,
                "quantity": e.quantity,
              })
          .toList(),
    };

    try {
      await apiService.createCart(payload);

      // ✅ Check if mounted *before* using context
      if (!mounted) return;

      // ✅ All context usage happens AFTER mounted check
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );

      cartProv.clearCart();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guest Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => v == null || v.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Submit Order'),
                      onPressed: () => _submitOrder(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
