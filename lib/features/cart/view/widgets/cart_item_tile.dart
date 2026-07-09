import 'package:flutter/material.dart';

import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../model/cart_item.dart';
import 'quantity_controls.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 74,
              height: 74,
              color: theme.colorScheme.surfaceContainerLowest,
              padding: const EdgeInsets.all(6),
              child: AppNetworkImage(url: item.image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  PriceFormatter.format(item.price),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    QuantityControls(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    const Spacer(),
                    Text(
                      PriceFormatter.format(item.subtotal),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove',
            icon: Icon(Icons.delete_outline_rounded,
                color: theme.colorScheme.error),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
