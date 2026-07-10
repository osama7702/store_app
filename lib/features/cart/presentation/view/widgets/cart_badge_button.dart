import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodel/cart_view_model.dart';

/// Cart icon button with a live item-count badge, for use in app bars.
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartViewModel, CartState>(
      buildWhen: (prev, curr) => prev.totalItems != curr.totalItems,
      builder: (context, state) {
        final count = state.totalItems;
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 4, end: 4),
          showBadge: count > 0,
          badgeStyle: badges.BadgeStyle(
            badgeColor: theme.colorScheme.error,
          ),
          badgeContent: Text(
            '$count',
            style: TextStyle(
              color: theme.colorScheme.onError,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: IconButton(
            tooltip: 'Cart',
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: onTap,
          ),
        );
      },
    );
  }
}
