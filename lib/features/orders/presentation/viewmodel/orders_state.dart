part of 'orders_view_model.dart';

enum OrdersStatus { initial, loading, placing, success, error }

class OrdersState extends Equatable {
  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.lastOrder,
    this.errorMessage,
  });

  final OrdersStatus status;
  final List<Order> orders;
  final Order? lastOrder;
  final String? errorMessage;

  bool get isEmpty => orders.isEmpty;

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    Order? lastOrder,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      lastOrder: lastOrder ?? this.lastOrder,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, lastOrder, errorMessage];
}
