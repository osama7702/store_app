part of 'favorites_cubit.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.favoriteIds = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  final Set<int> favoriteIds;
  final bool isLoading;
  final String? errorMessage;

  bool isFavorite(int id) => favoriteIds.contains(id);

  FavoritesState copyWith({
    Set<int>? favoriteIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [favoriteIds, isLoading, errorMessage];
}
