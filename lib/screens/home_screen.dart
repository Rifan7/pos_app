import 'package:flutter/material.dart';
import '../data/mock_products.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CartItem> _cartItems = [];

  void _addToCart(Product product) {
    setState(() {
      // Cek apakah produk sudah ada di keranjang
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex >= 0) {
        // Jika ada, tambahkan jumlahnya
        _cartItems[existingIndex].quantity++;
      } else {
        // Jika tidak ada, tambahkan sebagai item baru
        _cartItems.add(CartItem(product: product));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int get totalItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  void _navigateToCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CartScreen(cartItems: _cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS App'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _navigateToCart,
              ),
              if (totalItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$totalItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: mockProducts.length,
          itemBuilder: (ctx, index) {
            final product = mockProducts[index];
            return ProductCard(
              product: product,
              onAdd: _addToCart,
            );
          },
        ),
      ),
    );
  }
}