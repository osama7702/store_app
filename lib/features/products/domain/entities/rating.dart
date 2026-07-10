import 'package:equatable/equatable.dart';

/// A product's aggregate rating. Pure domain entity with no serialization
/// concerns — parsing lives in the data layer's RatingModel.
class Rating extends Equatable {
  const Rating({required this.rate, required this.count});

  final double rate;
  final int count;

  @override
  List<Object?> get props => [rate, count];
}
