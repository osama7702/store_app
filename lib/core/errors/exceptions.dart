/// Low-level exceptions thrown by data sources. These are translated into
/// user-facing [Failure]s at the repository layer.
class ServerException implements Exception {
  const ServerException([this.message = 'Server error occurred']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Local storage error']);
  final String message;
}
