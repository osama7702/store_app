import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Abstraction over connectivity so the data layer can check for internet
/// access without depending directly on a concrete package.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connection);

  final InternetConnection _connection;

  @override
  Future<bool> get isConnected => _connection.hasInternetAccess;
}
