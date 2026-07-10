import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';

/// Concrete [ProductsRepository] backed by a remote data source. Translates
/// data-layer exceptions into user-facing [Failure]s.
class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl({
    required ProductsRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  final ProductsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await _remoteDataSource.getProducts();
      return Right(products);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      // Distinguish a genuine offline state from a server-side error so the
      // user sees the most accurate message.
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.message ?? 'Failed to load products'));
    }
  }
}
