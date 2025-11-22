import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final Function() onIncrement;
  final Function() onDecrement;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          cartItem.product.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(cartItem.product.name),
      subtitle: Text('Rp ${cartItem.product.price.toStringAsFixed(0)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onDecrement,
          ),
          Text(
            cartItem.quantity.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}