import 'package:equatable/equatable.dart';

/// A product's aggregate rating. Doubles as the JSON model — it parses itself
/// from the API response, so there is no separate entity/model split.
class Rating extends Equatable {
  const Rating({required this.rate, required this.count});

  final double rate;
  final int count;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [rate, count];
}
