import '../../domain/entities/product.dart';
import 'rating_model.dart';

/// Data-layer representation of [Product] that knows how to parse itself from
/// the API JSON. Extends the entity so it can be used anywhere a [Product] is
/// expected.
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required RatingModel super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: RatingModel.fromJson(
        (json['rating'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}
