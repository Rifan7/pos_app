import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _incrementQuantity(CartItem item) {
    setState(() {
      item.quantity++;
    });
  }

  void _decrementQuantity(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        widget.cartItems.remove(item);
      }
    });
  }

  double get totalPrice {
    return widget.cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void _checkout() {
    if (widget.cartItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Checkout'),
        content: Text(
            'Total: Rp ${totalPrice.toStringAsFixed(0)}\n\nApakah Anda ingin melanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog
              Navigator.of(context).pop(); // Kembali ke halaman utama
              widget.cartItems.clear(); // Kosongkan keranjang
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout berhasil! Keranjang dikosongkan.'),
                ),
              );
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Anda'),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text('Keranjang Anda kosong.'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (ctx, index) {
                      final cartItem = widget.cartItems[index];
                      return CartItemTile(
                        cartItem: cartItem,
                        onIncrement: () => _incrementQuantity(cartItem),
                        onDecrement: () => _decrementQuantity(cartItem),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}