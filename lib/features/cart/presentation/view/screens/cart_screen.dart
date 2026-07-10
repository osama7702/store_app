import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/price_formatter.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../../orders/presentation/viewmodel/orders_view_model.dart';
import '../../viewmodel/cart_view_model.dart';
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

  /// Places the current cart as an order (persisted locally), then clears the
  /// cart and confirms to the user.
  Future<void> _checkout(BuildContext context, CartState cartState) async {
    final confirmed = await _confirm(
      context,
      title: 'Place order?',
      message: 'Confirm your order of ${cartState.totalItems} item(s) for '
          '${PriceFormatter.format(cartState.totalPrice)}?',
      confirmLabel: 'Place order',
    );
    if (!confirmed || !context.mounted) return;

    final ordersViewModel = context.read<OrdersViewModel>();
    final cartViewModel = context.read<CartViewModel>();
    final order =
        await ordersViewModel.placeOrder(cartState.items, DateTime.now());
    if (!context.mounted) return;

    if (order == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Could not place your order.')),
        );
      return;
    }

    await cartViewModel.clearCart();
    if (!context.mounted) return;

    // Capture app-level references before navigating away, so the confirmation
    // survives this screen being disposed.
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    // Back to the home screen after a successful purchase.
    router.go('/');

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Order ${order.id} placed successfully'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View orders',
            onPressed: () => router.push('/orders'),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          BlocBuilder<CartViewModel, CartState>(
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
                  if (ok) await viewModel.clearCart();
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartViewModel, CartState>(
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.initial:
            case CartStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CartStatus.error:
              return CustomErrorWidget(
                message: state.errorMessage ?? 'Could not load your cart.',
                onRetry: viewModel.loadCart,
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
                          onIncrement: () => viewModel.increment(item.productId),
                          onDecrement: () async {
                            if (item.quantity <= 1) {
                              final ok = await _confirm(
                                context,
                                title: 'Remove item?',
                                message:
                                    'Reduce to zero and remove "${item.title}" from the cart?',
                                confirmLabel: 'Remove',
                              );
                              if (ok) await viewModel.removeItem(item.productId);
                            } else {
                              await viewModel.decrement(item.productId);
                            }
                          },
                          onRemove: () async {
                            final ok = await _confirm(
                              context,
                              title: 'Remove item?',
                              message: 'Remove "${item.title}" from the cart?',
                              confirmLabel: 'Remove',
                            );
                            if (ok) await viewModel.removeItem(item.productId);
                          },
                        ).animate().fadeIn(duration: 250.ms);
                      },
                    ),
                  ),
                  BlocBuilder<OrdersViewModel, OrdersState>(
                    buildWhen: (p, c) => p.status != c.status,
                    builder: (context, ordersState) {
                      return CartTotalSection(
                        totalPrice: state.totalPrice,
                        totalItems: state.totalItems,
                        isPlacingOrder:
                            ordersState.status == OrdersStatus.placing,
                        onCheckout: () => _checkout(context, state),
                      );
                    },
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
