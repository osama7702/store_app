import 'package:fpdart/fpdart.dart' hide Order;

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

/// Reads all placed orders, newest first.
class GetOrders implements UseCase<List<Order>, NoParams> {
  GetOrders(this._repository);

  final OrdersRepository _repository;

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) =>
      _repository.getOrders();
}
