import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/cubit/products_cubit.dart';
import '../../../products/presentation/widgets/products_grid.dart';
import '../cubit/favorites_cubit.dart';

/// Shows only the products the user has favorited. Favorites are stored as
/// ids, so we resolve them against the already-loaded product list.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favState) {
          return BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, prodState) {
              final favorites = prodState.allProducts
                  .where((p) => favState.isFavorite(p.id))
                  .toList();

              if (favorites.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.favorite_border_rounded,
                  title: 'No favorites yet',
                  subtitle: 'Tap the heart on any product to save it here.',
                  action: FilledButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('Browse products'),
                  ),
                );
              }

              return ProductsGrid(
                products: favorites,
                onProductTap: (ProductEntity product) =>
                    context.push('/product-details', extra: product),
              );
            },
          );
        },
      ),
    );
  }
}
