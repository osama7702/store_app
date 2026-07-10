import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product.dart';

/// Domain contract for product data access. The presentation layer depends on
/// this abstraction; the concrete implementation lives in the data layer.
abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
