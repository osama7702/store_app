part of 'cart_view_model.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  final CartStatus status;
  final List<CartItem> items;
  final String? errorMessage;

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  int quantityOf(int productId) {
    for (final item in items) {
      if (item.productId == productId) return item.quantity;
    }
    return 0;
  }

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
