import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/price_formatter.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../domain/entities/order.dart';
import '../../viewmodel/orders_view_model.dart';

/// Shows the user's placed orders, newest first. Orders are read from the
/// local Sqflite store through [OrdersViewModel].
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OrdersViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrdersViewModel, OrdersState>(
        builder: (context, state) {
          switch (state.status) {
            case OrdersStatus.initial:
            case OrdersStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case OrdersStatus.error:
              return CustomErrorWidget(
                message: state.errorMessage ?? 'Could not load your orders.',
                onRetry: viewModel.loadOrders,
              );
            case OrdersStatus.placing:
            case OrdersStatus.success:
              if (state.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.receipt_long_outlined,
                  title: 'No orders yet',
                  subtitle: 'Your completed orders will appear here.',
                  action: FilledButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('Start shopping'),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _OrderCard(order: state.orders[index])
                      .animate()
                      .fadeIn(duration: 250.ms);
                },
              );
          }
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded,
                  size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.id,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                _formatDate(order.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      color: theme.colorScheme.surfaceContainerLowest,
                      padding: const EdgeInsets.all(4),
                      child: AppNetworkImage(url: item.image),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.quantity}× ${PriceFormatter.format(item.price)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.itemCount} items',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                PriceFormatter.format(order.total),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)} '
        '${two(date.hour)}:${two(date.minute)}';
  }
}
