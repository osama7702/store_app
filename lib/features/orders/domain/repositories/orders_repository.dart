import 'package:fpdart/fpdart.dart' hide Order;

import '../../../../core/errors/failure.dart';
import '../entities/order.dart';

/// Domain contract for order persistence.
abstract class OrdersRepository {
  Future<Either<Failure, Unit>> placeOrder(Order order);

  Future<Either<Failure, List<Order>>> getOrders();
}
