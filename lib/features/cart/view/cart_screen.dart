import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../core/utils.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../../product/bloc/product_bloc.dart';
import '../../product/bloc/product_state.dart'; // <-- PASTIKAN BARIS INI ADA
import '../../product/bloc/product_event.dart';
import '../../transaction/bloc/transaction_bloc.dart';
import '../../transaction/bloc/transaction_event.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: state.items.isEmpty
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Kosongkan Keranjang'),
                            content: const Text('Apakah Anda yakin?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(ClearCart());
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Ya'),
                              ),
                            ],
                          ),
                        );
                      },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
          if (productState is ProductLoaded) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                if (cartState.items.isEmpty) {
                  return const Center(child: Text('Keranjang Anda kosong.'));
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartState.items.length,
                        itemBuilder: (context, index) {
                          final product = cartState.items.values.elementAt(index);
                          final quantity = cartState.quantities[product.id] ?? 0;
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Text(currencyFormatter.format(product.price)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      context.read<CartBloc>().add(UpdateCartQuantity(product.id, quantity - 1));
                                    },
                                  ),
                                  Text('$quantity', style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      context.read<CartBloc>().add(UpdateCartQuantity(product.id, quantity + 1));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ${currencyFormatter.format(cartState.totalAmount)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () => _processPayment(context, cartState),
                            child: const Text('BAYAR'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _processPayment(BuildContext context, CartState cartState) {
    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: DateTime.now(),
      totalAmount: cartState.totalAmount,
      items: cartState.items.entries.map((entry) {
        final product = entry.value;
        final quantity = cartState.quantities[product.id] ?? 0;
        return TransactionItemModel(
          productId: product.id,
          productName: product.name,
          price: product.price,
          quantity: quantity,
        );
      }).toList(),
    );

    context.read<TransactionBloc>().add(AddTransaction(transaction));

    for (var item in transaction.items) {
      final productBox = Hive.box<ProductModel>('products');
      final product = productBox.get(item.productId);
      if (product != null) {
        product.stock -= item.quantity;
        product.save();
      }
    }

    context.read<ProductBloc>().add(LoadProducts());
    context.read<CartBloc>().add(ClearCart());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}