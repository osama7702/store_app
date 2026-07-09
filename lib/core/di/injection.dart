import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/cart/repository/cart_repository.dart';
import '../../features/cart/viewmodel/cart_view_model.dart';
import '../../features/favorites/repository/favorites_repository.dart';
import '../../features/favorites/viewmodel/favorites_view_model.dart';
import '../../features/products/repository/products_repository.dart';
import '../../features/products/viewmodel/products_view_model.dart';
import '../database/app_database.dart';
import '../network/dio_client.dart';
import '../theme/theme_view_model.dart';

final sl = GetIt.instance;

/// Registers every dependency. Call once at startup before running the app.
///
/// Wiring follows MVVM: repositories own data access, view models own state,
/// and the UI reads view models via BlocProvider.
Future<void> initDependencies() async {
  // ---- External ----
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());

  // ---- Repositories ----
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepository(
      dio: sl<DioClient>().dio,
      connection: sl<InternetConnection>(),
    ),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepository(sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepository(sl()),
  );

  // ---- View models (singletons: shared app-wide state) ----
  sl.registerLazySingleton<ThemeViewModel>(() => ThemeViewModel(sl()));
  sl.registerLazySingleton<ProductsViewModel>(() => ProductsViewModel(sl()));
  sl.registerLazySingleton<FavoritesViewModel>(() => FavoritesViewModel(sl()));
  sl.registerLazySingleton<CartViewModel>(() => CartViewModel(sl()));
}
