library api_client;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'src/api_response.dart';
import 'src/auth_interceptor.dart';
import 'src/token_refresh_interceptor.dart';
import 'src/connection_retry_interceptor.dart';

export 'src/api_response.dart';
export 'src/auth_interceptor.dart';
export 'src/token_refresh_interceptor.dart';
export 'src/connection_retry_interceptor.dart';

class ApiClient {
  late final Dio _dio;

  /// Creates a pre-configured [ApiClient] wrapping Dio.
  ///
  /// ### Retry dialog
  /// Pass [showRetryDialog] to enable the two-phase retry interceptor.
  /// The callback should display a UI dialog and return `true` (retry) or
  /// `false` (cancel).
  ///
  /// ```dart
  /// ApiClient(
  ///   baseUrl: config.baseUrl,
  ///   showRetryDialog: () async {
  ///     return await showDialog<bool>(
  ///       context: navigatorKey.currentContext!,
  ///       builder: (_) => const NetworkRetryDialog(),
  ///     ) ?? false;
  ///   },
  /// )
  /// ```
  ApiClient({
    required String baseUrl,
    Duration connectTimeout                = const Duration(seconds: 15),
    Duration receiveTimeout               = const Duration(seconds: 30),
    Map<String, dynamic>? defaultHeaders,
    String Function()?    tokenProvider,
    Future<String?> Function()? refreshToken,
    Future<bool> Function()?    showRetryDialog,
    bool enableLogging                    = true,
    // Retry tuning (optional)
    int maxAutoRetries                    = 10,
    int initialBackoffMs                  = 1000,
    int backoffStepMs                     = 500,
    int maxBackoffMs                      = 3000,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl:        baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader:      'application/json',
        ...?defaultHeaders,
      },
    ));

    // Order matters: auth → connection-retry → token-refresh → logging
    if (tokenProvider != null) {
      _dio.interceptors.add(AuthInterceptor(tokenProvider));
    }

    if (showRetryDialog != null) {
      _dio.interceptors.add(ConnectionRetryInterceptor(
        dio:             _dio,
        showRetryDialog: showRetryDialog,
        maxAutoRetries:  maxAutoRetries,
        initialBackoffMs: initialBackoffMs,
        backoffStepMs:   backoffStepMs,
        maxBackoffMs:    maxBackoffMs,
      ));
    }

    if (refreshToken != null) {
      _dio.interceptors.add(TokenRefreshInterceptor(dio: _dio, refreshToken: refreshToken));
    }

    if (enableLogging) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader:  true,
        requestBody:    true,
        responseBody:   true,
        responseHeader: false,
        error:          true,
        compact:        true,
      ));
    }
  }

  // ── Private request helper ─────────────────────────────────────────────────
  Future<ApiResponse<T>> _req<T>(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? qp,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    T Function(dynamic)? fromJson,
    CancelToken?    cancel,
    ProgressCallback? onSend,
    ProgressCallback? onReceive,
  }) async {
    try {
      final res = await _dio.request<dynamic>(
        path,
        data:            data,
        queryParameters: qp,
        options:         Options(method: method, headers: headers, extra: extra),
        cancelToken:     cancel,
        onSendProgress:  onSend,
        onReceiveProgress: onReceive,
      );
      final parsed = fromJson != null ? fromJson(res.data) : res.data as T;
      return ApiResponse.success(parsed, statusCode: res.statusCode ?? 200);
    } on DioException catch (e) {
      return ApiResponse.failure(_errorMessage(e), statusCode: e.response?.statusCode ?? 0);
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }

  // ── Public HTTP methods ────────────────────────────────────────────────────

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) => _req('GET', path, qp: queryParams, headers: headers, extra: extra, fromJson: fromJson, cancel: cancelToken);

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) => _req('POST', path, data: body, qp: queryParams, headers: headers, extra: extra, fromJson: fromJson, cancel: cancelToken, onSend: onSendProgress);

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) => _req('PUT', path, data: body, qp: queryParams, headers: headers, extra: extra, fromJson: fromJson, cancel: cancelToken);

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) => _req('PATCH', path, data: body, qp: queryParams, headers: headers, extra: extra, fromJson: fromJson, cancel: cancelToken);

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) => _req('DELETE', path, data: body, qp: queryParams, headers: headers, extra: extra, fromJson: fromJson, cancel: cancelToken);

  Future<ApiResponse<String>> uploadFile(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? extras,
    ProgressCallback? onSendProgress,
  }) async {
    final form = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
      ...?extras,
    });
    return _req('POST', path, data: form, fromJson: (d) => d.toString(), onSend: onSendProgress);
  }

  Future<ApiResponse<bool>> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
      return ApiResponse.success(true);
    } on DioException catch (e) {
      return ApiResponse.failure(_errorMessage(e));
    }
  }

  void cancelRequests(CancelToken token) => token.cancel('Cancelled');

  static String _errorMessage(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout => 'Connection timed out.',
    DioExceptionType.sendTimeout       => 'Send timed out.',
    DioExceptionType.receiveTimeout    => 'Response timed out.',
    DioExceptionType.cancel            => 'Request was cancelled.',
    DioExceptionType.connectionError   => 'No internet connection.',
    _                                  => e.response?.data?['message']?.toString()
                                          ?? e.message
                                          ?? 'Unknown error.',
  };
}
