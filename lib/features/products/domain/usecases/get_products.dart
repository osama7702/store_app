import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

/// Fetches the full product catalog from the repository.
class GetProducts implements UseCase<List<Product>, NoParams> {
  GetProducts(this._repository);

  final ProductsRepository _repository;

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) =>
      _repository.getProducts();
}
