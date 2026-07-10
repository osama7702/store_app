import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cart_item_model.dart';

/// Local data source contract for the cart. Throws [CacheException] on error.
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> removeFromCart(int productId);
  Future<void> clearCart();
}

/// Sqflite-backed implementation. Owns the SQL directly.
class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  static const _table = AppConstants.cartTable;

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(_table, orderBy: 'title COLLATE NOCASE ASC');
      return rows.map(CartItemModel.fromMap).toList();
    } catch (_) {
      throw const CacheException('Could not read cart');
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    try {
      final db = await _appDatabase.database;
      await db.transaction((txn) async {
        final existing = await txn.query(
          _table,
          where: 'product_id = ?',
          whereArgs: [item.productId],
          limit: 1,
        );
        if (existing.isEmpty) {
          await txn.insert(_table, item.toMap());
        } else {
          final current = existing.first['quantity'] as int;
          await txn.update(
            _table,
            {'quantity': current + item.quantity},
            where: 'product_id = ?',
            whereArgs: [item.productId],
          );
        }
      });
    } catch (_) {
      throw const CacheException('Could not update cart');
    }
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(productId);
        return;
      }
      final db = await _appDatabase.database;
      await db.update(
        _table,
        {'quantity': quantity},
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    } catch (_) {
      throw const CacheException('Could not update quantity');
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      final db = await _appDatabase.database;
      await db.delete(_table, where: 'product_id = ?', whereArgs: [productId]);
    } catch (_) {
      throw const CacheException('Could not remove item');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final db = await _appDatabase.database;
      await db.delete(_table);
    } catch (_) {
      throw const CacheException('Could not clear cart');
    }
  }
}
