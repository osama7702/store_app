import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
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

  @override
  List<Object?> get props => [productId, title, price, image, quantity];
}
