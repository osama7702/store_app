import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../models/order_model.dart';

/// Local data source contract for orders. Throws [CacheException] on error.
abstract class OrdersLocalDataSource {
  Future<void> placeOrder(OrderModel order);
  Future<List<OrderModel>> getOrders();
}

/// Sqflite-backed implementation. Order line items live in a separate table
/// linked back to the parent order via `order_id`.
class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  OrdersLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  static const _ordersTable = AppConstants.ordersTable;
  static const _itemsTable = AppConstants.orderItemsTable;

  @override
  Future<void> placeOrder(OrderModel order) async {
    try {
      final db = await _appDatabase.database;
      await db.transaction((txn) async {
        await txn.insert(_ordersTable, order.toMap());
        for (final item in order.items) {
          await txn.insert(_itemsTable, {
            'order_id': order.id,
            ...CartItemModel.fromEntity(item).toMap(),
          });
        }
      });
    } catch (_) {
      throw const CacheException('Could not place order');
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final db = await _appDatabase.database;
      final orderRows = await db.query(
        _ordersTable,
        orderBy: 'created_at DESC',
      );
      final orders = <OrderModel>[];
      for (final row in orderRows) {
        final itemRows = await db.query(
          _itemsTable,
          where: 'order_id = ?',
          whereArgs: [row['id']],
        );
        final items = itemRows.map(CartItemModel.fromMap).toList();
        orders.add(OrderModel.fromMap(row, items));
      }
      return orders;
    } catch (_) {
      throw const CacheException('Could not read orders');
    }
  }
}
