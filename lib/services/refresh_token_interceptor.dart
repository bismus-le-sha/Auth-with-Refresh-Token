import 'package:dio/dio.dart';
import 'package:flutter_refresh_token/services/api_service.dart';
import 'package:flutter_refresh_token/services/token_refresher.dart';
import 'secure_storage_service.dart';

class RefreshTokenInterceptor extends Interceptor {
  final ApiService _api;
  final Dio _dio;

  RefreshTokenInterceptor({required ApiService api, required Dio dio})
      : _api = api,
        _dio = dio;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await SecureStorageManager.readData('accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      String? refreshToken =
          await SecureStorageManager.readData('refreshToken');
      if (refreshToken == null) {
        await SecureStorageManager.clearAllData();
        handler.next(err);
        return;
      }

      try {
        final newAccessToken =
            await TokenRefresher.refreshToken(_api, refreshToken);
        if (newAccessToken == null) {
          handler.next(err);
          return;
        }

        // retry original request
        final retryOptions = err.requestOptions
          ..headers['Authorization'] = 'Bearer $newAccessToken';
        final response = await _dio.fetch(retryOptions);
        handler.resolve(response);
      } catch (e) {
        await SecureStorageManager.clearAllData();
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
