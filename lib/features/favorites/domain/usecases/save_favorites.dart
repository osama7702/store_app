import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

/// Persists the full set of favorite product ids.
class SaveFavorites implements UseCase<Unit, List<int>> {
  SaveFavorites(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(List<int> ids) =>
      _repository.saveFavoriteIds(ids);
}
