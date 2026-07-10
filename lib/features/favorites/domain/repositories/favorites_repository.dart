import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';

/// Domain contract for favorites persistence. Favorites are modeled as a set
/// of product ids, so there is no dedicated entity.
abstract class FavoritesRepository {
  Future<Either<Failure, List<int>>> getFavoriteIds();

  Future<Either<Failure, Unit>> saveFavoriteIds(List<int> ids);
}
