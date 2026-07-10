import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/price_formatter.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../../../core/widgets/favorite_button.dart';
import '../../../../cart/presentation/view/widgets/cart_badge_button.dart';
import '../../../../cart/presentation/viewmodel/cart_view_model.dart';
import '../../../domain/entities/product.dart';
import 'image_preview_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  void _addToCart(BuildContext context) {
    context.read<CartViewModel>().addProduct(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Product added to cart successfully'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () => context.push('/cart'),
          ),
        ),
      );
  }

  void _openPreview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImagePreviewScreen(imageUrl: product.image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          FavoriteButton(productId: product.id),
          CartBadgeButton(onTap: () => context.push('/cart')),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Hero image.
          GestureDetector(
            onTap: () => _openPreview(context),
            child: Container(
              height: 320,
              color: theme.colorScheme.surfaceContainerLowest,
              padding: const EdgeInsets.all(24),
              child: Hero(
                tag: 'product-image-${product.id}',
                child: AppNetworkImage(url: product.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CategoryChip(label: product.category),
                    const Spacer(),
                    Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: Colors.amber.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating.rate} (${product.rating.count})',
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  product.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  PriceFormatter.format(product.price),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Persistent bottom bar: "Add to Cart" until the item is in the cart,
      // then a quantity stepper.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 54,
            child: BlocBuilder<CartViewModel, CartState>(
              buildWhen: (prev, curr) =>
                  prev.quantityOf(product.id) != curr.quantityOf(product.id),
              builder: (context, state) {
                final quantity = state.quantityOf(product.id);
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: quantity == 0
                      ? ElevatedButton.icon(
                          key: const ValueKey('add'),
                          onPressed: () => _addToCart(context),
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: const Text('Add to Cart'),
                        )
                      : _DetailsStepper(
                          key: const ValueKey('stepper'),
                          quantity: quantity,
                          onIncrement: () => context
                              .read<CartViewModel>()
                              .increment(product.id),
                          onDecrement: () => context
                              .read<CartViewModel>()
                              .decrement(product.id),
                          onViewCart: () => context.push('/cart'),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom-bar quantity stepper shown on the details screen once the product
/// is in the cart. Includes a shortcut to view the cart.
class _DetailsStepper extends StatelessWidget {
  const _DetailsStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onViewCart,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onViewCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              _StepButton(
                icon: quantity <= 1
                    ? Icons.delete_outline_rounded
                    : Icons.remove_rounded,
                onTap: onDecrement,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '$quantity',
                    key: ValueKey(quantity),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _StepButton(icon: Icons.add_rounded, onTap: onIncrement),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: onViewCart,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('View Cart'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Icon(icon, size: 22, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
