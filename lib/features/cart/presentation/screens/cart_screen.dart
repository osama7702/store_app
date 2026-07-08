import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_total_section.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            buildWhen: (p, c) => p.isEmpty != c.isEmpty,
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Clear cart',
                icon: const Icon(Icons.remove_shopping_cart_outlined),
                onPressed: () async {
                  final ok = await _confirm(
                    context,
                    title: 'Clear cart?',
                    message: 'This will remove all items from your cart.',
                    confirmLabel: 'Clear',
                  );
                  if (ok) await cubit.clearCart();
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.initial:
            case CartStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CartStatus.error:
              return CustomErrorWidget(
                message: state.errorMessage ?? 'Could not load your cart.',
                onRetry: cubit.loadCart,
              );
            case CartStatus.success:
              if (state.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Your cart is empty',
                  subtitle: 'Browse products and add items to your cart.',
                  action: FilledButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('Start shopping'),
                  ),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return CartItemTile(
                          item: item,
                          onIncrement: () => cubit.increment(item.productId),
                          onDecrement: () async {
                            if (item.quantity <= 1) {
                              final ok = await _confirm(
                                context,
                                title: 'Remove item?',
                                message:
                                    'Reduce to zero and remove "${item.title}" from the cart?',
                                confirmLabel: 'Remove',
                              );
                              if (ok) await cubit.removeItem(item.productId);
                            } else {
                              await cubit.decrement(item.productId);
                            }
                          },
                          onRemove: () async {
                            final ok = await _confirm(
                              context,
                              title: 'Remove item?',
                              message: 'Remove "${item.title}" from the cart?',
                              confirmLabel: 'Remove',
                            );
                            if (ok) await cubit.removeItem(item.productId);
                          },
                        ).animate().fadeIn(duration: 250.ms);
                      },
                    ),
                  ),
                  CartTotalSection(
                    totalPrice: state.totalPrice,
                    totalItems: state.totalItems,
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
