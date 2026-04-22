import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A two-phase network retry interceptor.
///
/// **Phase 1 – Automatic retries** (silent, background)
/// On a connection error the request is retried up to [maxAutoRetries] times
/// with progressive back-off (1 s → 1.5 s → 2 s … capped at [maxBackoffMs]).
///
/// **Phase 2 – Manual retry** (UI prompt)
/// Once automatic retries are exhausted a [showRetryDialog] callback is
/// invoked.  If the user chooses to retry the counter resets and Phase 1
/// begins again.  If they cancel the original error is propagated.
///
/// ## Usage
/// ```dart
/// dio.interceptors.add(
///   ConnectionRetryInterceptor(
///     dio: dio,
///     showRetryDialog: () async {
///       // Show your dialog here and return true to retry, false to cancel.
///       return await MyDialog.show();
///     },
///   ),
/// );
/// ```
///
/// ### Optional loading-state integration
/// Pass a `loadingState` key in `requestOptions.extra` pointing to any
/// object that has a `call(bool)` setter (e.g. `ValueNotifier<bool>` wrapper
/// or a GetX `RxBool`).  The interceptor will call `loadingState(false)`
/// before showing the dialog and `loadingState(true)` before retrying.
///
/// ```dart
/// client.get('/endpoint', extra: {'loadingState': myRxBool});
/// ```
class ConnectionRetryInterceptor extends Interceptor {
  final Dio dio;

  /// Maximum number of silent automatic retries before the dialog is shown.
  final int maxAutoRetries;

  /// The initial back-off delay in milliseconds.
  final int initialBackoffMs;

  /// Back-off is incremented by this value per retry.
  final int backoffStepMs;

  /// Maximum back-off ceiling in milliseconds.
  final int maxBackoffMs;

  /// Called when automatic retries are exhausted.
  /// Return `true` → reset counter and retry.
  /// Return `false` → propagate the error.
  final Future<bool> Function() showRetryDialog;

  // Ensures only one dialog is visible at a time across all concurrent requests.
  static bool _isDialogVisible = false;

  ConnectionRetryInterceptor({
    required this.dio,
    required this.showRetryDialog,
    this.maxAutoRetries   = 10,
    this.initialBackoffMs = 1000,
    this.backoffStepMs    = 500,
    this.maxBackoffMs     = 3000,
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // ── Only handle connection-level errors ──────────────────────────────────
    if (!_isConnectionError(err)) {
      return handler.next(err);
    }

    final options = err.requestOptions;

    // Safely mutate a copy of the extra map so we don't share state.
    options.extra = Map<String, dynamic>.from(options.extra);

    int retryCount = (options.extra['retryCount'] as int?) ?? 0;
    final dynamic loadingState = options.extra['loadingState'];

    // ─────────────────────────────────────────────────────────────────────────
    // PHASE 1: AUTOMATIC RETRY
    // ─────────────────────────────────────────────────────────────────────────
    if (retryCount < maxAutoRetries) {
      retryCount++;
      options.extra['retryCount'] = retryCount;

      final delayMs = (initialBackoffMs + (retryCount - 1) * backoffStepMs)
          .clamp(initialBackoffMs, maxBackoffMs);

      debugPrint(
        '🌐 [RetryInterceptor] Auto-retry $retryCount/$maxAutoRetries '
        'for ${options.path} — waiting ${delayMs}ms',
      );

      await Future<void>.delayed(Duration(milliseconds: delayMs));

      try {
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PHASE 2: MANUAL RETRY (dialog)
    // ─────────────────────────────────────────────────────────────────────────
    debugPrint(
      '🌐 [RetryInterceptor] Max auto-retries reached for ${options.path}. '
      'Showing dialog.',
    );

    // Pause the loading indicator while the dialog is visible.
    _invokeLoadingState(loadingState, false);

    if (_isDialogVisible) {
      // Another request is already showing the dialog — reject immediately.
      return handler.reject(err);
    }

    _isDialogVisible = true;
    final bool shouldRetry;
    try {
      shouldRetry = await showRetryDialog();
    } finally {
      _isDialogVisible = false;
    }

    if (shouldRetry) {
      // Reset counter so Phase 1 runs again.
      options.extra['retryCount'] = 0;
      _invokeLoadingState(loadingState, true);

      try {
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    } else {
      return handler.reject(err);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns true for network/socket errors that warrant a retry.
  /// HTTP 4xx/5xx responses are NOT retried — those are server-side failures.
  bool _isConnectionError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;

      case DioExceptionType.unknown:
        // No response → the request never reached the server (Wi-Fi drop,
        // DNS failure, broken socket).
        if (err.response == null) return true;

        // Fallback string-match for OS-level errors.
        final msg = err.error?.toString().toLowerCase() ?? '';
        return msg.contains('socketexception') ||
            msg.contains('httpexception') ||
            msg.contains('handshakeexception') ||
            msg.contains('failed host lookup') ||
            msg.contains('connection failed') ||
            msg.contains('network is unreachable');

      default:
        return false;
    }
  }

  /// Safely calls loadingState(value) if the object supports it.
  void _invokeLoadingState(dynamic loadingState, bool value) {
    if (loadingState == null) return;
    try {
      // Works with any callable: RxBool, ValueNotifier wrapper, etc.
      (loadingState as dynamic).call(value);
    } catch (_) {
      // Silently ignore if the object doesn't support call().
    }
  }
}
