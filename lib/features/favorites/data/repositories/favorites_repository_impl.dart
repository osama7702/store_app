import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

/// Concrete [FavoritesRepository] backed by SharedPreferences.
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<int>>> getFavoriteIds() async {
    try {
      return Right(await _localDataSource.getFavoriteIds());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Could not access local storage.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveFavoriteIds(List<int> ids) async {
    try {
      await _localDataSource.saveFavoriteIds(ids);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Could not access local storage.'));
    }
  }
}
