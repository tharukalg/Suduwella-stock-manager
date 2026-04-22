import 'package:dio/dio.dart';

/// Attaches a Bearer token to every outgoing request.
class AuthInterceptor extends Interceptor {
  final String Function() tokenProvider;

  AuthInterceptor(this.tokenProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider();
    if (token.isNotEmpty) options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}
