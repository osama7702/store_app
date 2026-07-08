import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../cart/presentation/widgets/cart_badge_button.dart';
import '../../domain/entities/product_entity.dart';
import '../cubit/products_cubit.dart';
import '../widgets/category_filter.dart';
import '../widgets/products_grid.dart';
import '../widgets/search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetails(BuildContext context, ProductEntity product) {
    context.push('/product-details', extra: product);
  }

  @override
  Widget build(BuildContext context) {
    final productsCubit = context.read<ProductsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () => context.push('/favorites'),
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                tooltip: 'Toggle theme',
                icon: Icon(isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded),
                onPressed: () => context.read<ThemeCubit>().toggle(),
              );
            },
          ),
          CartBadgeButton(onTap: () => context.push('/cart')),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchField(
                        initialValue: state.searchQuery,
                        onChanged: productsCubit.search,
                        onClear: productsCubit.clearSearch,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SortButton(
                      current: state.sortType,
                      onSelected: productsCubit.changeSort,
                    ),
                  ],
                ),
              ),
              if (state.status == ProductsStatus.success)
                CategoryFilter(
                  categories: state.categories,
                  selected: state.selectedCategory,
                  onSelected: productsCubit.selectCategory,
                ),
              const SizedBox(height: 4),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsState state) {
    final productsCubit = context.read<ProductsCubit>();

    switch (state.status) {
      case ProductsStatus.initial:
      case ProductsStatus.loading:
        return ProductsGrid(
          products: const [],
          isLoading: true,
          onProductTap: (_) {},
        );
      case ProductsStatus.error:
        return CustomErrorWidget(
          message: state.failureMessage ?? 'Something went wrong.',
          onRetry: productsCubit.fetchProducts,
        );
      case ProductsStatus.success:
        if (state.filteredProducts.isEmpty) {
          final searching = state.searchQuery.isNotEmpty ||
              state.selectedCategory != kAllCategories;
          return RefreshIndicator(
            onRefresh: productsCubit.refresh,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: EmptyStateWidget(
                    icon: searching
                        ? Icons.search_off_rounded
                        : Icons.inventory_2_outlined,
                    title: searching
                        ? 'No products found'
                        : 'No products available',
                    subtitle: searching
                        ? 'Try a different search or category.'
                        : 'Pull down to refresh.',
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: productsCubit.refresh,
          child: ProductsGrid(
            products: state.filteredProducts,
            onProductTap: (product) => _openDetails(context, product),
          ),
        );
    }
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.current, required this.onSelected});

  final SortType current;
  final ValueChanged<SortType> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = current != SortType.none;
    return PopupMenuButton<SortType>(
      tooltip: 'Sort',
      initialValue: current,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (context) => [
        for (final type in SortType.values)
          PopupMenuItem(value: type, child: Text(type.label)),
      ],
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: active
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.sort_rounded,
          color: active
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
