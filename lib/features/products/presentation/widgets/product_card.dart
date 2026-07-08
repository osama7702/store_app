import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/favorite_button.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/product_entity.dart';

/// Grid card showing image, title, price, favorite and add-to-cart.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductEntity product;
  final VoidCallback onTap;

  void _addToCart(BuildContext context) {
    context.read<CartCubit>().addProduct(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Product added to cart successfully'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + favorite overlay.
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Hero(
                        tag: 'product-image-${product.id}',
                        child: AppNetworkImage(url: product.image),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Material(
                      color: theme.colorScheme.surface.withValues(alpha: 0.7),
                      shape: const CircleBorder(),
                      child: FavoriteButton(productId: product.id, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            // Details.
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600, height: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          PriceFormatter.format(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.star_rounded,
                          size: 16, color: Colors.amber.shade600),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.rate.toStringAsFixed(1),
                        style: theme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _CartAction(
                    product: product,
                    onAdd: () => _addToCart(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Trailing action on a product card: shows an "add" button when the product
/// isn't in the cart, and swaps to a compact +/- quantity stepper once it is.
class _CartAction extends StatelessWidget {
  const _CartAction({required this.product, required this.onAdd});

  final ProductEntity product;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) =>
          prev.quantityOf(product.id) != curr.quantityOf(product.id),
      builder: (context, state) {
        final quantity = state.quantityOf(product.id);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: SizedBox(
            width: double.infinity,
            child: quantity == 0
                ? _AddButton(key: const ValueKey('add'), onPressed: onAdd)
                : _MiniStepper(
                    key: const ValueKey('stepper'),
                    quantity: quantity,
                    onIncrement: () =>
                        context.read<CartCubit>().increment(product.id),
                    onDecrement: () =>
                        context.read<CartCubit>().decrement(product.id),
                  ),
          ),
        );
      },
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_shopping_cart_rounded,
                size: 18,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                'Add',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact +/- stepper sized to fit inside a product card.
class _MiniStepper extends StatelessWidget {
  const _MiniStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepIcon(
            icon: quantity <= 1
                ? Icons.delete_outline_rounded
                : Icons.remove_rounded,
            onTap: onDecrement,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              '$quantity',
              key: ValueKey(quantity),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _StepIcon(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Icon(icon, size: 18, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
