import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/place_order.dart';

part 'orders_state.dart';

/// View model for placing and listing orders, persisted in Sqflite through the
/// order use cases.
class OrdersViewModel extends Cubit<OrdersState> {
  OrdersViewModel({
    required GetOrders getOrders,
    required PlaceOrder placeOrder,
  }) : _getOrders = getOrders,
       _placeOrder = placeOrder,
       super(const OrdersState());

  final GetOrders _getOrders;
  final PlaceOrder _placeOrder;

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading, errorMessage: null));
    final result = await _getOrders(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (orders) =>
          emit(state.copyWith(status: OrdersStatus.success, orders: orders)),
    );
  }

  /// Creates an order from the given cart items and persists it. Returns the
  /// placed order on success, or null on failure / empty cart.
  Future<Order?> placeOrder(List<CartItem> items, DateTime placedAt) async {
    if (items.isEmpty) return null;
    emit(state.copyWith(status: OrdersStatus.placing, errorMessage: null));
    final result = await _placeOrder(
      PlaceOrderParams(items: items, placedAt: placedAt),
    );
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OrdersStatus.error,
            errorMessage: failure.message,
          ),
        );
        return null;
      },
      (order) {
        emit(
          state.copyWith(
            status: OrdersStatus.success,
            orders: [order, ...state.orders],
            lastOrder: order,
          ),
        );
        return order;
      },
    );
  }
}
