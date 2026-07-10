import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

/// Reads the persisted favorite product ids.
class GetFavorites implements UseCase<List<int>, NoParams> {
  GetFavorites(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, List<int>>> call(NoParams params) =>
      _repository.getFavoriteIds();
}
