import '../entities/product_entity.dart';

abstract class ProductsRepository {
  /// Returns the full product list or throws a [Failure] on error.
  Future<List<ProductEntity>> getProducts();
}
