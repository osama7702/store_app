import '../../domain/entities/cart_item.dart';

/// Data-layer representation of [CartItem] that maps to and from a Sqflite row.
class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.image,
    required super.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['product_id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      quantity: map['quantity'] as int,
    );
  }

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      productId: item.productId,
      title: item.title,
      price: item.price,
      image: item.image,
      quantity: item.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}
