import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_quantity.dart';

part 'cart_state.dart';

/// View model for the shopping cart, persisted in Sqflite through the cart
/// use cases. Every mutation writes to the database first, then reloads state
/// so the UI and storage stay in sync.
class CartViewModel extends Cubit<CartState> {
  CartViewModel({
    required GetCartItems getCartItems,
    required AddToCart addToCart,
    required UpdateCartQuantity updateCartQuantity,
    required RemoveFromCart removeFromCart,
    required ClearCart clearCart,
  })  : _getCartItems = getCartItems,
        _addToCart = addToCart,
        _updateCartQuantity = updateCartQuantity,
        _removeFromCart = removeFromCart,
        _clearCart = clearCart,
        super(const CartState());

  final GetCartItems _getCartItems;
  final AddToCart _addToCart;
  final UpdateCartQuantity _updateCartQuantity;
  final RemoveFromCart _removeFromCart;
  final ClearCart _clearCart;

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    final result = await _getCartItems(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: CartStatus.error, errorMessage: failure.message),
      ),
      (items) =>
          emit(state.copyWith(status: CartStatus.success, items: items)),
    );
  }

  /// Adds a product to the cart. If it already exists the quantity is
  /// incremented rather than adding a duplicate row.
  Future<void> addProduct(Product product) async {
    await _mutate(_addToCart(
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
    await _mutate(_updateCartQuantity(
      UpdateCartQuantityParams(productId: productId, quantity: current + 1),
    ));
  }

  /// Decrements quantity; removes the item entirely when it reaches zero.
  Future<void> decrement(int productId) async {
    final current = state.quantityOf(productId);
    await _mutate(_updateCartQuantity(
      UpdateCartQuantityParams(productId: productId, quantity: current - 1),
    ));
  }

  Future<void> removeItem(int productId) async {
    await _mutate(_removeFromCart(productId));
  }

  Future<void> clearCart() async {
    await _mutate(_clearCart(const NoParams()));
  }

  /// Awaits a repository write then reloads the cart from the database so the
  /// emitted state always reflects persisted data.
  Future<void> _mutate(Future<Either<Failure, Unit>> action) async {
    final result = await action;
    await result.fold(
      (failure) async =>
          emit(state.copyWith(errorMessage: failure.message)),
      (_) async {
        final items = await _getCartItems(const NoParams());
        items.fold(
          (failure) => emit(state.copyWith(errorMessage: failure.message)),
          (list) =>
              emit(state.copyWith(status: CartStatus.success, items: list)),
        );
      },
    );
  }
}
