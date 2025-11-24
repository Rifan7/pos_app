import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../../../data/models/product_model.dart'; // <-- TAMBAHKAN BARIS INI

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) {
    final updatedItems = Map<String, ProductModel>.from(state.items);
    final updatedQuantities = Map<String, int>.from(state.quantities);

    updatedItems[event.product.id] = event.product;
    updatedQuantities[event.product.id] = (updatedQuantities[event.product.id] ?? 0) + 1;

    emit(state.copyWith(items: updatedItems, quantities: updatedQuantities));
  }

  void _onRemoveProductFromCart(RemoveProductFromCart event, Emitter<CartState> emit) {
    final updatedItems = Map<String, ProductModel>.from(state.items);
    final updatedQuantities = Map<String, int>.from(state.quantities);

    updatedItems.remove(event.productId);
    updatedQuantities.remove(event.productId);

    emit(state.copyWith(items: updatedItems, quantities: updatedQuantities));
  }

  void _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) {
    final updatedQuantities = Map<String, int>.from(state.quantities);
    if (event.quantity <= 0) {
      add(RemoveProductFromCart(event.productId));
    } else {
      updatedQuantities[event.productId] = event.quantity;
      emit(state.copyWith(quantities: updatedQuantities));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}