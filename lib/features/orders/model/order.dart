import 'package:equatable/equatable.dart';

import '../../cart/model/cart_item.dart';

/// A placed order. Reuses [CartItem] for its line items and maps to/from the
/// `orders` Sqflite row (its items are persisted separately in `order_items`).
class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.itemCount,
    required this.createdAt,
  });

  final String id;
  final List<CartItem> items;
  final double total;
  final int itemCount;
  final DateTime createdAt;

  /// Builds an order from the current cart contents, deriving the id from the
  /// creation time so it is unique and sortable.
  factory Order.fromCart(List<CartItem> items, DateTime createdAt) {
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    final count = items.fold<int>(0, (sum, item) => sum + item.quantity);
    return Order(
      id: 'ORD-${createdAt.millisecondsSinceEpoch}',
      items: items,
      total: total,
      itemCount: count,
      createdAt: createdAt,
    );
  }

  factory Order.fromMap(Map<String, dynamic> map, List<CartItem> items) {
    return Order(
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

  @override
  List<Object?> get props => [id, items, total, itemCount, createdAt];
}
