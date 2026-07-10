import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

/// Concrete [CartRepository] backed by a Sqflite local data source. Translates
/// [CacheException]s into [CacheFailure]s.
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._localDataSource);

  final CartLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() {
    return _guard(() => _localDataSource.getCartItems());
  }

  @override
  Future<Either<Failure, Unit>> addToCart(CartItem item) {
    return _guardUnit(
      () => _localDataSource.addToCart(CartItemModel.fromEntity(item)),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateQuantity(int productId, int quantity) {
    return _guardUnit(
      () => _localDataSource.updateQuantity(productId, quantity),
    );
  }

  @override
  Future<Either<Failure, Unit>> removeFromCart(int productId) {
    return _guardUnit(() => _localDataSource.removeFromCart(productId));
  }

  @override
  Future<Either<Failure, Unit>> clearCart() {
    return _guardUnit(() => _localDataSource.clearCart());
  }

  /// Runs a read that returns a value, mapping exceptions to failures.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Could not access local storage.'));
    }
  }

  /// Runs a write with no return value, mapping exceptions to failures.
  Future<Either<Failure, Unit>> _guardUnit(
    Future<void> Function() action,
  ) async {
    try {
      await action();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Could not access local storage.'));
    }
  }
}
