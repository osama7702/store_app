import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Empties the cart.
class ClearCart implements UseCase<Unit, NoParams> {
  ClearCart(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.clearCart();
}
