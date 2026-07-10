import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Reads all items currently in the cart.
class GetCartItems implements UseCase<List<CartItem>, NoParams> {
  GetCartItems(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) =>
      _repository.getCartItems();
}
