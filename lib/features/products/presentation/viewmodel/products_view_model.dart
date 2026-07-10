import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

part 'products_state.dart';

/// View model for the product catalog. Owns fetching, refreshing, searching,
/// sorting and category filtering. All list transformations are performed
/// locally after the initial fetch. Data access goes through the [GetProducts]
/// use case rather than a repository directly.
class ProductsViewModel extends Cubit<ProductsState> {
  ProductsViewModel(this._getProducts) : super(const ProductsState());

  final GetProducts _getProducts;

  Future<void> fetchProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading, failureMessage: null));
    final result = await _getProducts(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        failureMessage: failure.message,
      )),
      (products) {
        final categories = _extractCategories(products);
        emit(
          state.copyWith(
            status: ProductsStatus.success,
            allProducts: products,
            categories: categories,
          ),
        );
        _applyFilters();
      },
    );
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

  List<String> _extractCategories(List<Product> products) {
    final set = <String>{for (final p in products) p.category};
    return [kAllCategories, ...set];
  }

  /// Recomputes [filteredProducts] from [allProducts] using the current
  /// search query, selected category and sort type.
  void _applyFilters() {
    var list = List<Product>.from(state.allProducts);

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
