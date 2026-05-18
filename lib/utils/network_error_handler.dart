import 'package:dio/dio.dart';

class NetworkErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      // 1. Try to extract message from response data
      if (error.response?.data is Map) {
        final data = error.response!.data as Map;
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
      }

      // 2. Fallback to Dio error types
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet and try again.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          return 'Server error ($statusCode). Please try again later.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.connectionError:
          return 'Unable to connect to the server. Please check your connection.';
        case DioExceptionType.unknown:
          if (error.message?.contains('SocketException') ?? false) {
            return 'No internet connection.';
          }
          return 'An unexpected error occurred.';
        default:
          return error.message ?? 'Something went wrong. Please try again.';
      }
    }

    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }

    return error.toString();
  }
}
