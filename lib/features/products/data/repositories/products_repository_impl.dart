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
    // Let the actual request be the source of truth for connectivity — a
    // pre-flight ping is flaky on cold start and can fail the first attempt
    // even when the network is fine.
    try {
      return await remoteDataSource.getProducts();
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      // Distinguish a genuine offline state from a server-side error so the
      // user sees the most accurate message.
      if (!await networkInfo.isConnected) {
        throw const NetworkFailure();
      }
      throw ServerFailure(e.message);
    }
  }
}
