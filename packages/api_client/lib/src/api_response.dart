class ApiResponse<T> {
  final T?      data;
  final String? error;
  final int     statusCode;
  final bool    isSuccess;

  const ApiResponse._({
    this.data,
    this.error,
    required this.statusCode,
    required this.isSuccess,
  });

  factory ApiResponse.success(T data, {int statusCode = 200}) =>
      ApiResponse._(data: data, statusCode: statusCode, isSuccess: true);

  factory ApiResponse.failure(String error, {int statusCode = 0}) =>
      ApiResponse._(error: error, statusCode: statusCode, isSuccess: false);
}
