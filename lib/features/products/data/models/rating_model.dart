import '../../domain/entities/rating.dart';

/// Data-layer representation of [Rating] that knows how to parse itself from
/// the API JSON.
class RatingModel extends Rating {
  const RatingModel({required super.rate, required super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}
