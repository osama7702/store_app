import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/save_favorites.dart';

part 'favorites_state.dart';

/// View model for the set of favorite product ids, persisted via the favorites
/// use cases (SharedPreferences under the hood).
class FavoritesViewModel extends Cubit<FavoritesState> {
  FavoritesViewModel({
    required GetFavorites getFavorites,
    required SaveFavorites saveFavorites,
  }) : _getFavorites = getFavorites,
       _saveFavorites = saveFavorites,
       super(const FavoritesState());

  final GetFavorites _getFavorites;
  final SaveFavorites _saveFavorites;

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getFavorites(const NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (ids) => emit(state.copyWith(favoriteIds: ids.toSet(), isLoading: false)),
    );
  }

  Future<void> toggleFavorite(int productId) async {
    final updated = Set<int>.from(state.favoriteIds);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    // Optimistically update UI, then persist.
    emit(state.copyWith(favoriteIds: updated));
    final result = await _saveFavorites(updated.toList());
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {},
    );
  }
}
