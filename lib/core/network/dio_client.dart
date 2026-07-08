import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import 'api_endpoints.dart';

/// Thin wrapper that configures a single [Dio] instance for the app.
class DioClient {
  DioClient() : dio = _build();

  final Dio dio;

  static Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        responseType: ResponseType.json,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    return dio;
  }
}
