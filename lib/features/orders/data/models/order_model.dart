import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';

/// Data-layer representation of [Order]. Maps to/from the `orders` Sqflite row;
/// its line items are persisted separately in the `order_items` table.
class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.items,
    required super.total,
    required super.itemCount,
    required super.createdAt,
  });

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      items: order.items,
      total: order.total,
      itemCount: order.itemCount,
      createdAt: order.createdAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, List<CartItem> items) {
    return OrderModel(
      id: map['id'] as String,
      items: items,
      total: (map['total'] as num).toDouble(),
      itemCount: map['item_count'] as int,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'item_count': itemCount,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}
