/// App-wide constant values used across features.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Product Catalog';

  // Shared preferences keys.
  static const String favoritesKey = 'favorite_product_ids';
  static const String themeModeKey = 'theme_mode';

  // Sqflite database.
  static const String dbName = 'app_cart.db';
  static const int dbVersion = 1;
  static const String cartTable = 'cart_items';

  // Networking.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // UX.
  static const Duration searchDebounce = Duration(milliseconds: 350);
}
