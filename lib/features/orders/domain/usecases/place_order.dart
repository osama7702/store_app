import 'package:fpdart/fpdart.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

/// Builds an order from the given cart items and persists it, returning the
/// placed order on success.
class PlaceOrder implements UseCase<Order, PlaceOrderParams> {
  PlaceOrder(this._repository);

  final OrdersRepository _repository;

  @override
  Future<Either<Failure, Order>> call(PlaceOrderParams params) async {
    final order = Order.fromCart(params.items, params.placedAt);
    final result = await _repository.placeOrder(order);
    return result.map((_) => order);
  }
}

class PlaceOrderParams extends Equatable {
  const PlaceOrderParams({required this.items, required this.placedAt});

  final List<CartItem> items;
  final DateTime placedAt;

  @override
  List<Object?> get props => [items, placedAt];
}
