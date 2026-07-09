import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failure.dart';

/// Persists favorite product ids in SharedPreferences. Reads/writes directly
/// and throws [CacheFailure] on any error.
class FavoritesRepository {
  FavoritesRepository(this._prefs);

  final SharedPreferences _prefs;

  Future<List<int>> getFavoriteIds() async {
    try {
      final stored = _prefs.getStringList(AppConstants.favoritesKey) ?? [];
      return stored.map(int.parse).toList();
    } catch (_) {
      throw const CacheFailure('Could not read favorites');
    }
  }

  Future<void> saveFavoriteIds(List<int> ids) async {
    try {
      await _prefs.setStringList(
        AppConstants.favoritesKey,
        ids.map((e) => e.toString()).toList(),
      );
    } catch (_) {
      throw const CacheFailure('Could not save favorites');
    }
  }
}
