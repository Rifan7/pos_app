import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../data/models/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final Box<ProductModel> productBox;

  ProductBloc(this.productBox) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) {
    try {
      emit(ProductLoading());
      final products = productBox.values.toList();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Gagal memuat produk: $e'));
    }
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) {
    try {
      productBox.put(event.product.id, event.product);
      add(LoadProducts());
    } catch (e) {
      emit(ProductError('Gagal menambah produk: $e'));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) {
    try {
      event.product.save();
      add(LoadProducts());
    } catch (e) {
      emit(ProductError('Gagal mengupdate produk: $e'));
    }
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) {
    try {
      productBox.delete(event.productId);
      add(LoadProducts());
    } catch (e) {
      emit(ProductError('Gagal menghapus produk: $e'));
    }
  }
}