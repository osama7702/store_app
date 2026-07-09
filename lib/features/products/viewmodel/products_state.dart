part of 'products_view_model.dart';

enum ProductsStatus { initial, loading, success, error }

/// How the product grid is ordered.
enum SortType {
  none('Default'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  topRated('Top Rated');

  const SortType(this.label);
  final String label;
}

/// Sentinel category meaning "show everything".
const String kAllCategories = 'all';

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.selectedCategory = kAllCategories,
    this.searchQuery = '',
    this.sortType = SortType.none,
    this.failureMessage,
  });

  final ProductsStatus status;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final SortType sortType;
  final String? failureMessage;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    SortType? sortType,
    String? failureMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sortType: sortType ?? this.sortType,
      failureMessage: failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProducts,
        filteredProducts,
        categories,
        selectedCategory,
        searchQuery,
        sortType,
        failureMessage,
      ];
}
