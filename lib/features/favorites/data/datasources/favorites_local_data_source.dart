import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

/// Local data source contract for favorites. Throws [CacheException] on error.
abstract class FavoritesLocalDataSource {
  Future<List<int>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<int> ids);
}

/// SharedPreferences-backed implementation. Stores ids as a string list.
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<List<int>> getFavoriteIds() async {
    try {
      final stored = _prefs.getStringList(AppConstants.favoritesKey) ?? [];
      return stored.map(int.parse).toList();
    } catch (_) {
      throw const CacheException('Could not read favorites');
    }
  }

  @override
  Future<void> saveFavoriteIds(List<int> ids) async {
    try {
      await _prefs.setStringList(
        AppConstants.favoritesKey,
        ids.map((e) => e.toString()).toList(),
      );
    } catch (_) {
      throw const CacheException('Could not save favorites');
    }
  }
}
