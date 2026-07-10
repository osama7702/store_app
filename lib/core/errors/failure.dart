import 'package:equatable/equatable.dart';

/// User-facing failure carried up to the presentation layer.
/// Every [Failure] has a human readable [message] safe to show in the UI.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not access local storage.']);
}
