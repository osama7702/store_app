import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../repository/favorites_repository.dart';

part 'favorites_state.dart';

/// View model for the set of favorite product ids, persisted via
/// SharedPreferences.
class FavoritesViewModel extends Cubit<FavoritesState> {
  FavoritesViewModel(this._repository) : super(const FavoritesState());

  final FavoritesRepository _repository;

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final ids = await _repository.getFavoriteIds();
      emit(state.copyWith(favoriteIds: ids.toSet(), isLoading: false));
    } on Failure catch (f) {
      emit(state.copyWith(isLoading: false, errorMessage: f.message));
    }
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
    try {
      await _repository.saveFavoriteIds(updated.toList());
    } on Failure catch (f) {
      emit(state.copyWith(errorMessage: f.message));
    }
  }
}
