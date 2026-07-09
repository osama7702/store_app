import 'package:equatable/equatable.dart';

import 'rating.dart';

/// A single catalog product. This is the MVVM "model": a plain data class that
/// also knows how to parse itself from the API JSON.
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: Rating.fromJson(
        (json['rating'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }

  @override
  List<Object?> get props =>
      [id, title, price, description, category, image, rating];
}
