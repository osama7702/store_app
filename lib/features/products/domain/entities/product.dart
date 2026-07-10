import 'package:equatable/equatable.dart';

import 'rating.dart';

/// A single catalog product. Pure domain entity — it knows nothing about JSON
/// or persistence; those concerns live in the data layer's ProductModel.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    rating,
  ];
}
