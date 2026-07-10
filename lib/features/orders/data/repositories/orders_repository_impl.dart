import 'package:fpdart/fpdart.dart' hide Order;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_local_data_source.dart';
import '../models/order_model.dart';

/// Concrete [OrdersRepository] backed by a Sqflite local data source.
class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._localDataSource);

  final OrdersLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, Unit>> placeOrder(Order order) async {
    try {
      await _localDataSource.placeOrder(OrderModel.fromEntity(order));
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Could not access local storage.'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      return Right(await _localDataSource.getOrders());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Could not access local storage.'));
    }
  }
}
