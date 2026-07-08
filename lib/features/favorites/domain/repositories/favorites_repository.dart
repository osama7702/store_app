abstract class FavoritesRepository {
  Future<List<int>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<int> ids);
}
