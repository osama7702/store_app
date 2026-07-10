import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart.dart';
import '../../features/cart/domain/usecases/clear_cart.dart';
import '../../features/cart/domain/usecases/get_cart_items.dart';
import '../../features/cart/domain/usecases/remove_from_cart.dart';
import '../../features/cart/domain/usecases/update_cart_quantity.dart';
import '../../features/cart/presentation/viewmodel/cart_view_model.dart';
import '../../features/favorites/data/datasources/favorites_local_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/save_favorites.dart';
import '../../features/favorites/presentation/viewmodel/favorites_view_model.dart';
import '../../features/orders/data/datasources/orders_local_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_orders.dart';
import '../../features/orders/domain/usecases/place_order.dart';
import '../../features/orders/presentation/viewmodel/orders_view_model.dart';
import '../../features/products/data/datasources/products_remote_data_source.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/presentation/viewmodel/products_view_model.dart';
import '../database/app_database.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../theme/theme_view_model.dart';

final sl = GetIt.instance;

/// Registers every dependency across the three Clean Architecture layers.
/// Call once at startup before running the app.
///
/// Wiring direction: presentation (view models) → domain (use cases →
/// repository contracts) ← data (repository impls → data sources → externals).
Future<void> initDependencies() async {
  // ---- External ----
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ---- Data sources ----
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OrdersLocalDataSource>(
    () => OrdersLocalDataSourceImpl(sl()),
  );

  // ---- Repositories (contract ← implementation) ----
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));

  // ---- Use cases ----
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetCartItems(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantity(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => SaveFavorites(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));

  // ---- View models (singletons: shared app-wide state) ----
  sl.registerLazySingleton<ThemeViewModel>(() => ThemeViewModel(sl()));
  sl.registerLazySingleton<ProductsViewModel>(() => ProductsViewModel(sl()));
  sl.registerLazySingleton<FavoritesViewModel>(
    () => FavoritesViewModel(getFavorites: sl(), saveFavorites: sl()),
  );
  sl.registerLazySingleton<CartViewModel>(
    () => CartViewModel(
      getCartItems: sl(),
      addToCart: sl(),
      updateCartQuantity: sl(),
      removeFromCart: sl(),
      clearCart: sl(),
    ),
  );
  sl.registerLazySingleton<OrdersViewModel>(
    () => OrdersViewModel(getOrders: sl(), placeOrder: sl()),
  );
}
