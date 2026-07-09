import 'package:equatable/equatable.dart';

/// A line item in the shopping cart. Doubles as the persistence model —
/// it maps to and from a Sqflite row.
class CartItem extends Equatable {
  const CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  final int productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  double get subtotal => price * quantity;

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['product_id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      quantity: map['quantity'] as int,
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

  @override
  List<Object?> get props => [productId, title, price, image, quantity];
}
