import 'package:flutter/material.dart';

import '../../../../core/utils/price_formatter.dart';

/// Sticky bottom bar showing the cart total and a checkout button.
class CartTotalSection extends StatelessWidget {
  const CartTotalSection({
    super.key,
    required this.totalPrice,
    required this.totalItems,
    required this.onCheckout,
    this.isPlacingOrder = false,
  });

  final double totalPrice;
  final int totalItems;
  final VoidCallback onCheckout;
  final bool isPlacingOrder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ($totalItems items)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  PriceFormatter.format(totalPrice),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isPlacingOrder ? null : onCheckout,
                icon: isPlacingOrder
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shopping_bag_outlined),
                label: Text(isPlacingOrder ? 'Placing order...' : 'Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
