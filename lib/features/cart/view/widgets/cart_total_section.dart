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
            const SizedBox(height: 16),
            _CheckoutButton(
              totalPrice: totalPrice,
              isPlacingOrder: isPlacingOrder,
              onCheckout: onCheckout,
            ),
          ],
        ),
      ),
    );
  }
}

/// Gradient checkout button with a trailing price pill. Shows an inline spinner
/// while the order is being placed and disables interaction meanwhile.
class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton({
    required this.totalPrice,
    required this.isPlacingOrder,
    required this.onCheckout,
  });

  final double totalPrice;
  final bool isPlacingOrder;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gradientEnd = Color.lerp(scheme.primary, Colors.black, 0.18)!;
    final radius = BorderRadius.circular(16);

    return Semantics(
      button: true,
      enabled: !isPlacingOrder,
      label: 'Checkout',
      child: Opacity(
        opacity: isPlacingOrder ? 0.7 : 1,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [scheme.primary, gradientEnd],
              ),
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: radius,
              onTap: isPlacingOrder ? null : onCheckout,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: isPlacingOrder
                    ? _buildPlacing(scheme)
                    : _buildIdle(context, scheme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlacing(ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Placing order...',
          style: TextStyle(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildIdle(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        Spacer(),
        Icon(Icons.shopping_bag_outlined, color: scheme.onPrimary, size: 22),
        const SizedBox(width: 10),
        Text(
          'Checkout',
          style: TextStyle(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        const Spacer(),
        // // Price pill on the trailing edge.
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: scheme.onPrimary.withValues(alpha: 0.18),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Text(
        //     PriceFormatter.format(totalPrice),
        //     style: TextStyle(
        //       color: scheme.onPrimary,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 15,
        //     ),
        //   ),
        // ),
        // const SizedBox(width: 8),
        Icon(Icons.arrow_forward_rounded, color: scheme.onPrimary, size: 20),
      ],
    );
  }
}
