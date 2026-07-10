import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Adds a product to the cart (or increments its quantity if present).
class AddToCart implements UseCase<Unit, CartItem> {
  AddToCart(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CartItem params) =>
      _repository.addToCart(params);
}
