class AppException implements Exception {
  final String  message;
  final int?    statusCode;
  final dynamic data;

  const AppException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'AppException($statusCode): $message';
}

class NetworkException      extends AppException { const NetworkException(super.m, {super.statusCode}); }
class UnauthorizedException extends AppException { const UnauthorizedException([String m = 'Unauthorized.'])    : super(m, statusCode: 401); }
class NotFoundException     extends AppException { const NotFoundException([String m = 'Not found.'])           : super(m, statusCode: 404); }
class ServerException       extends AppException { const ServerException([String m = 'Server error.'])          : super(m, statusCode: 500); }
class TimeoutException      extends AppException { const TimeoutException([String m = 'Request timed out.'])    : super(m); }
class NoInternetException   extends AppException { const NoInternetException([String m = 'No internet.'])       : super(m); }
