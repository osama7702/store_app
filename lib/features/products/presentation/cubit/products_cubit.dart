import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';

part 'products_state.dart';

/// Owns fetching, refreshing, searching, sorting and category filtering.
/// All list transformations are performed locally after the initial fetch.
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState());

  final ProductsRepository _repository;

  Future<void> fetchProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading, failureMessage: null));
    try {
      final products = await _repository.getProducts();
      final categories = _extractCategories(products);
      emit(
        state.copyWith(
          status: ProductsStatus.success,
          allProducts: products,
          categories: categories,
        ),
      );
      _applyFilters();
    } on Failure catch (f) {
      emit(state.copyWith(
        status: ProductsStatus.error,
        failureMessage: f.message,
      ));
    }
  }

  Future<void> refresh() => fetchProducts();

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
    _applyFilters();
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
    _applyFilters();
  }

  void changeSort(SortType sortType) {
    emit(state.copyWith(sortType: sortType));
    _applyFilters();
  }

  List<String> _extractCategories(List<ProductEntity> products) {
    final set = <String>{for (final p in products) p.category};
    return [kAllCategories, ...set];
  }

  /// Recomputes [filteredProducts] from [allProducts] using the current
  /// search query, selected category and sort type.
  void _applyFilters() {
    var list = List<ProductEntity>.from(state.allProducts);

    if (state.selectedCategory != kAllCategories) {
      list = list.where((p) => p.category == state.selectedCategory).toList();
    }

    final query = state.searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((p) => p.title.toLowerCase().contains(query)).toList();
    }

    switch (state.sortType) {
      case SortType.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortType.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortType.topRated:
        list.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
      case SortType.none:
        break;
    }

    emit(state.copyWith(filteredProducts: list));
  }
}
