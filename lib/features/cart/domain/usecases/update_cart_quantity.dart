import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Sets an item's quantity. A quantity of zero or less removes the item.
class UpdateCartQuantity implements UseCase<Unit, UpdateCartQuantityParams> {
  UpdateCartQuantity(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UpdateCartQuantityParams params) =>
      _repository.updateQuantity(params.productId, params.quantity);
}

class UpdateCartQuantityParams extends Equatable {
  const UpdateCartQuantityParams({
    required this.productId,
    required this.quantity,
  });

  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}
