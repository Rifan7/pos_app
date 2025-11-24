import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddProductToCart extends CartEvent {
  final ProductModel product;

  const AddProductToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveProductFromCart extends CartEvent {
  final String productId;

  const RemoveProductFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateCartQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateCartQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}