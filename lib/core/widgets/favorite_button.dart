import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/favorites/presentation/cubit/favorites_cubit.dart';

/// Heart toggle wired to [FavoritesCubit] with a small pop animation and a
/// clear color change between states.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.productId,
    this.size = 24,
  });

  final int productId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (prev, curr) =>
          prev.isFavorite(productId) != curr.isFavorite(productId),
      builder: (context, state) {
        final isFav = state.isFavorite(productId);
        return IconButton(
          tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
          iconSize: size,
          onPressed: () =>
              context.read<FavoritesCubit>().toggleFavorite(productId),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isFav),
              color: isFav ? Colors.redAccent : null,
            ),
          ),
        );
      },
    );
  }
}
