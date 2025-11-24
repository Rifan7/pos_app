import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

class CartState extends Equatable {
  final Map<String, ProductModel> items;
  final Map<String, int> quantities;

  const CartState({this.items = const {}, this.quantities = const {}});

  double get totalAmount {
    double total = 0.0;
    for (var entry in items.entries) {
      total += entry.value.price * (quantities[entry.key] ?? 0);
    }
    return total;
  }

  int get totalItems {
    return quantities.values.fold(0, (sum, qty) => sum + qty);
  }

  CartState copyWith({
    Map<String, ProductModel>? items,
    Map<String, int>? quantities,
  }) {
    return CartState(
      items: items ?? this.items,
      quantities: quantities ?? this.quantities,
    );
  }

  @override
  List<Object> get props => [items, quantities];
}