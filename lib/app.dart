import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_view_model.dart';
import 'features/cart/presentation/viewmodel/cart_view_model.dart';
import 'features/favorites/presentation/viewmodel/favorites_view_model.dart';
import 'features/orders/presentation/viewmodel/orders_view_model.dart';
import 'features/products/presentation/viewmodel/products_view_model.dart';

class ProductCatalogApp extends StatelessWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeViewModel>()),
        BlocProvider.value(value: sl<ProductsViewModel>()..fetchProducts()),
        BlocProvider.value(value: sl<FavoritesViewModel>()..loadFavorites()),
        BlocProvider.value(value: sl<CartViewModel>()..loadCart()),
        BlocProvider.value(value: sl<OrdersViewModel>()..loadOrders()),
      ],
      child: BlocBuilder<ThemeViewModel, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
