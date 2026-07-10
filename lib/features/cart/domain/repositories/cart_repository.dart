import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/cart_item.dart';

/// Domain contract for cart persistence.
abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();

  /// Adds the item, or increments quantity if the product already exists.
  Future<Either<Failure, Unit>> addToCart(CartItem item);

  Future<Either<Failure, Unit>> updateQuantity(int productId, int quantity);

  Future<Either<Failure, Unit>> removeFromCart(int productId);

  Future<Either<Failure, Unit>> clearCart();
}
