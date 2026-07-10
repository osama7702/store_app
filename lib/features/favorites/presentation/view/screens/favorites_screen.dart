import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../../products/domain/entities/product.dart';
import '../../../../products/presentation/view/widgets/products_grid.dart';
import '../../../../products/presentation/viewmodel/products_view_model.dart';
import '../../viewmodel/favorites_view_model.dart';

/// Shows only the products the user has favorited. Favorites are stored as
/// ids, so we resolve them against the already-loaded product list.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesViewModel, FavoritesState>(
        builder: (context, favState) {
          return BlocBuilder<ProductsViewModel, ProductsState>(
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
                onProductTap: (Product product) =>
                    context.push('/product-details', extra: product),
              );
            },
          );
        },
      ),
    );
  }
}
