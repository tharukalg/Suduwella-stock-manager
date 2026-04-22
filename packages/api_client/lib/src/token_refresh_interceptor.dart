import 'package:dio/dio.dart';

/// On a 401 response, silently refreshes the token and retries the request.
class TokenRefreshInterceptor extends Interceptor {
  final Dio dio;
  final Future<String?> Function() refreshToken;

  TokenRefreshInterceptor({required this.dio, required this.refreshToken});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final token = await refreshToken();
      if (token != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        return handler.resolve(await dio.fetch(err.requestOptions));
      }
    }
    super.onError(err, handler);
  }
}
