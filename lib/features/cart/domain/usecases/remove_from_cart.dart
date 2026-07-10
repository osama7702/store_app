import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Removes a product from the cart entirely.
class RemoveFromCart implements UseCase<Unit, int> {
  RemoveFromCart(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int productId) =>
      _repository.removeFromCart(productId);
}
