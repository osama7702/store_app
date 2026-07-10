import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

/// Base contract for every use case in the domain layer.
///
/// A use case is a single, named business operation. It receives [Params] and
/// returns either a [Failure] or a [Type], keeping error handling explicit and
/// pushing side effects behind the repository contracts.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Marker for use cases that take no arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
