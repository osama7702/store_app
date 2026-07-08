import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._localDataSource);

  final CartLocalDataSource _localDataSource;

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    return _guard(() => _localDataSource.getCartItems());
  }

  @override
  Future<void> addToCart(CartItemEntity item) async {
    return _guard(() => _localDataSource.addOrIncrement(_toModel(item)));
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    return _guard(() => _localDataSource.setQuantity(productId, quantity));
  }

  @override
  Future<void> removeFromCart(int productId) async {
    return _guard(() => _localDataSource.removeItem(productId));
  }

  @override
  Future<void> clearCart() async {
    return _guard(() => _localDataSource.clear());
  }

  CartItemModel _toModel(CartItemEntity e) => CartItemModel(
        productId: e.productId,
        title: e.title,
        price: e.price,
        image: e.image,
        quantity: e.quantity,
      );

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
