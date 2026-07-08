import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  const RatingEntity({required this.rate, required this.count});

  final double rate;
  final int count;

  @override
  List<Object?> get props => [rate, count];
}
