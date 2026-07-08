import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<List<int>> getFavoriteIds() async {
    try {
      return await _localDataSource.getFavoriteIds();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> saveFavoriteIds(List<int> ids) async {
    try {
      await _localDataSource.saveFavoriteIds(ids);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
