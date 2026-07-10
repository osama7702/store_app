import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failure.dart';
import '../../cart/model/cart_item.dart';
import '../model/order.dart';

/// Persists placed orders in Sqflite. Owns the SQL directly (no separate
/// data-source layer) and throws [CacheFailure] on any error.
class OrdersRepository {
  OrdersRepository(this._appDatabase);

  final AppDatabase _appDatabase;

  static const _ordersTable = AppConstants.ordersTable;
  static const _itemsTable = AppConstants.orderItemsTable;

  /// Inserts the order and all of its line items atomically.
  Future<void> placeOrder(Order order) async {
    try {
      final db = await _appDatabase.database;
      await db.transaction((txn) async {
        await txn.insert(_ordersTable, order.toMap());
        for (final item in order.items) {
          await txn.insert(_itemsTable, {
            'order_id': order.id,
            ...item.toMap(),
          });
        }
      });
    } catch (_) {
      throw const CacheFailure('Could not place order');
    }
  }

  /// Reads all orders newest-first, each with its line items.
  Future<List<Order>> getOrders() async {
    try {
      final db = await _appDatabase.database;
      final orderRows =
          await db.query(_ordersTable, orderBy: 'created_at DESC');
      final orders = <Order>[];
      for (final row in orderRows) {
        final itemRows = await db.query(
          _itemsTable,
          where: 'order_id = ?',
          whereArgs: [row['id']],
        );
        final items = itemRows.map(CartItem.fromMap).toList();
        orders.add(Order.fromMap(row, items));
      }
      return orders;
    } catch (_) {
      throw const CacheFailure('Could not read orders');
    }
  }
}
