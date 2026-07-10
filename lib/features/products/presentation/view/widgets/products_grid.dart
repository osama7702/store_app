import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/rating.dart';
import 'product_card.dart';

/// Responsive grid of [ProductCard]s. When [isLoading] is true it renders
/// skeleton placeholders using Skeletonizer instead of a spinner.
class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    this.isLoading = false,
  });

  final List<Product> products;
  final ValueChanged<Product> onProductTap;
  final bool isLoading;

  static final List<Product> _skeletonItems = List.generate(
    6,
    (i) => Product(
      id: -i - 1,
      title: 'Loading product name placeholder',
      price: 99.99,
      description: '',
      category: '',
      image: '',
      rating: const Rating(rate: 4.5, count: 100),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final items = isLoading ? _skeletonItems : products;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.gridColumns(constraints.maxWidth);
        return Skeletonizer(
          enabled: isLoading,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              final card = ProductCard(
                product: product,
                onTap: isLoading ? () {} : () => onProductTap(product),
              );
              if (isLoading) return card;
              return card
                  .animate()
                  .fadeIn(
                    duration: 350.ms,
                    delay: (40 * (index % columns)).ms,
                  )
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
            },
          ),
        );
      },
    );
  }
}
