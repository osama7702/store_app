import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/product.dart';

/// Data access for products. In this lean MVVM setup the repository talks to
/// Dio directly (no separate data-source layer) and throws user-facing
/// [Failure]s that the view model surfaces to the UI.
class ProductsRepository {
  ProductsRepository({required Dio dio, required InternetConnection connection})
      : _dio = dio,
        _connection = connection;

  final Dio _dio;
  final InternetConnection _connection;

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get(ApiEndpoints.products);
      final data = response.data as List<dynamic>;
      return data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        throw const NetworkFailure();
      }
      // Distinguish a genuine offline state from a server-side error so the
      // user sees the most accurate message.
      if (!await _connection.hasInternetAccess) {
        throw const NetworkFailure();
      }
      throw ServerFailure(e.message ?? 'Failed to load products');
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure();
    }
  }

  /// True when the failure is due to connectivity rather than the server.
  bool _isConnectionError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      case DioExceptionType.unknown:
        // Dio wraps SocketException (no route to host / DNS failure) here.
        return e.error.toString().contains('SocketException');
      default:
        return false;
    }
  }
}
