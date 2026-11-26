import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  DioClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          final serverMessage = error.response?.data is Map<String, dynamic>
              ? error.response?.data['message']?.toString()
              : null;

          final friendlyMessage = serverMessage ??
              switch (error.type) {
                DioExceptionType.connectionTimeout ||
                DioExceptionType.sendTimeout ||
                DioExceptionType.receiveTimeout =>
                  'Bağlantı zaman aşımına uğradı.',
                DioExceptionType.connectionError =>
                  'İnternet bağlantısı kurulamadı.',
                _ => 'Beklenmeyen bir hata oluştu.',
              };

          return handler.reject(
            error.copyWith(message: friendlyMessage),
          );
        },
      ),
    );
  }

  Dio get instance => _dio;
}