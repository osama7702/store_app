import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../../products/model/product.dart';
import '../model/cart_item.dart';
import '../repository/cart_repository.dart';

part 'cart_state.dart';

/// View model for the shopping cart, persisted in Sqflite through
/// [CartRepository]. Every mutation writes to the database first, then reloads
/// state so the UI and storage stay in sync.
class CartViewModel extends Cubit<CartState> {
  CartViewModel(this._repository) : super(const CartState());

  final CartRepository _repository;

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    try {
      final items = await _repository.getCartItems();
      emit(state.copyWith(status: CartStatus.success, items: items));
    } on Failure catch (f) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: f.message));
    }
  }

  /// Adds a product to the cart. If it already exists the quantity is
  /// incremented rather than adding a duplicate row.
  Future<void> addProduct(Product product) async {
    await _mutate(() => _repository.addToCart(
          CartItem(
            productId: product.id,
            title: product.title,
            price: product.price,
            image: product.image,
            quantity: 1,
          ),
        ));
  }

  Future<void> increment(int productId) async {
    final current = state.quantityOf(productId);
    await _mutate(() => _repository.updateQuantity(productId, current + 1));
  }

  /// Decrements quantity; removes the item entirely when it reaches zero.
  Future<void> decrement(int productId) async {
    final current = state.quantityOf(productId);
    await _mutate(() => _repository.updateQuantity(productId, current - 1));
  }

  Future<void> removeItem(int productId) async {
    await _mutate(() => _repository.removeFromCart(productId));
  }

  Future<void> clearCart() async {
    await _mutate(() => _repository.clearCart());
  }

  /// Runs a repository write then reloads the cart from the database so the
  /// emitted state always reflects persisted data.
  Future<void> _mutate(Future<void> Function() action) async {
    try {
      await action();
      final items = await _repository.getCartItems();
      emit(state.copyWith(status: CartStatus.success, items: items));
    } on Failure catch (f) {
      emit(state.copyWith(errorMessage: f.message));
    }
  }
}
