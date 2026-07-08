import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final ProductsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<List<ProductEntity>> getProducts() async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure();
    }
    try {
      return await remoteDataSource.getProducts();
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
