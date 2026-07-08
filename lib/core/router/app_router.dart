import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/products/domain/entities/product_entity.dart';
import '../../features/products/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../widgets/empty_state_widget.dart';

/// Central go_router configuration for the app.
class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/product-details',
        builder: (context, state) {
          final product = state.extra;
          if (product is! ProductEntity) {
            return const Scaffold(
              body: EmptyStateWidget(
                icon: Icons.error_outline_rounded,
                title: 'Product not found',
              ),
            );
          }
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
  );
}
