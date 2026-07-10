// Low-level exceptions thrown by the data layer (data sources).
//
// These stay *inside* the data layer: repository implementations catch them
// and translate them into user-facing Failures. The domain and presentation
// layers never see these types.

/// Thrown by a remote data source when the API call fails.
class ServerException implements Exception {
  const ServerException([this.message]);

  final String? message;
}

/// Thrown by a remote data source when there is no connectivity.
class NetworkException implements Exception {
  const NetworkException();
}

/// Thrown by a local data source (Sqflite / SharedPreferences) on any error.
class CacheException implements Exception {
  const CacheException([this.message]);

  final String? message;
}
