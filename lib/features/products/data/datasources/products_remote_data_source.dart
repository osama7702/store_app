import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(ApiEndpoints.products);
      final data = response.data as List<dynamic>;
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        throw const NetworkException();
      }
      throw ServerException(e.message ?? 'Failed to load products');
    } catch (_) {
      throw const ServerException();
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
