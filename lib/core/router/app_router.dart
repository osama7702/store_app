import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/view/screens/cart_screen.dart';
import '../../features/favorites/view/screens/favorites_screen.dart';
import '../../features/orders/view/screens/orders_screen.dart';
import '../../features/products/model/product.dart';
import '../../features/products/view/screens/home_screen.dart';
import '../../features/products/view/screens/product_details_screen.dart';
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
          if (product is! Product) {
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
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
    ],
  );
}
