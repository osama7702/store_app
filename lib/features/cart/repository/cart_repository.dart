import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failure.dart';
import '../model/cart_item.dart';

/// Persists the shopping cart in Sqflite. The repository owns the SQL directly
/// (no separate data-source layer) and throws [CacheFailure] on any error.
class CartRepository {
  CartRepository(this._appDatabase);

  final AppDatabase _appDatabase;

  static const _table = AppConstants.cartTable;

  Future<List<CartItem>> getCartItems() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(_table, orderBy: 'title COLLATE NOCASE ASC');
      return rows.map(CartItem.fromMap).toList();
    } catch (_) {
      throw const CacheFailure('Could not read cart');
    }
  }

  /// Adds the item, or increments quantity by [item.quantity] if it exists.
  Future<void> addToCart(CartItem item) async {
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
      throw const CacheFailure('Could not update cart');
    }
  }

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
      throw const CacheFailure('Could not update quantity');
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      final db = await _appDatabase.database;
      await db.delete(_table, where: 'product_id = ?', whereArgs: [productId]);
    } catch (_) {
      throw const CacheFailure('Could not remove item');
    }
  }

  Future<void> clearCart() async {
    try {
      final db = await _appDatabase.database;
      await db.delete(_table);
    } catch (_) {
      throw const CacheFailure('Could not clear cart');
    }
  }
}
