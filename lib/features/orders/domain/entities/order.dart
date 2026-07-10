import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_item.dart';

/// A placed order. Pure domain entity. Reuses [CartItem] for its line items;
/// persistence mapping lives in the data layer's OrderModel.
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

  @override
  List<Object?> get props => [id, items, total, itemCount, createdAt];
}
