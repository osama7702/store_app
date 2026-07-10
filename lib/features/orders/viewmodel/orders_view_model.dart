import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../../cart/model/cart_item.dart';
import '../model/order.dart';
import '../repository/orders_repository.dart';

part 'orders_state.dart';

/// View model for placing and listing orders, persisted in Sqflite through
/// [OrdersRepository].
class OrdersViewModel extends Cubit<OrdersState> {
  OrdersViewModel(this._repository) : super(const OrdersState());

  final OrdersRepository _repository;

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading, errorMessage: null));
    try {
      final orders = await _repository.getOrders();
      emit(state.copyWith(status: OrdersStatus.success, orders: orders));
    } on Failure catch (f) {
      emit(state.copyWith(status: OrdersStatus.error, errorMessage: f.message));
    }
  }

  /// Creates an order from the given cart items and persists it. Returns the
  /// placed order on success, or null on failure.
  Future<Order?> placeOrder(List<CartItem> items, DateTime placedAt) async {
    if (items.isEmpty) return null;
    emit(state.copyWith(status: OrdersStatus.placing, errorMessage: null));
    try {
      final order = Order.fromCart(items, placedAt);
      await _repository.placeOrder(order);
      emit(state.copyWith(
        status: OrdersStatus.success,
        orders: [order, ...state.orders],
        lastOrder: order,
      ));
      return order;
    } on Failure catch (f) {
      emit(state.copyWith(status: OrdersStatus.error, errorMessage: f.message));
      return null;
    }
  }
}
