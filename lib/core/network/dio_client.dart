import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/core/network/api_endpoints.dart';
import 'package:zinko_app/core/network/auth_interceptor.dart';

class DioClient {
  final Dio _dio;
  final SharedPreferences sharedPreferences;

  DioClient(this._dio, this.sharedPreferences) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.responseType = ResponseType.json;

    // 1. Add Auth Interceptor for global token/401 handling
    _dio.interceptors.add(AuthInterceptor(sharedPreferences));

    // 2. Add Pretty Logger for debugging
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
      );
    }
  }

  // GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _validateResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _validateResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Common response validation for API internal status codes
  Response _validateResponse(Response response) {
    if (response.data is Map) {
      final json = response.data as Map;
      // Check if the body contains a statusCode that indicates failure
      if (json.containsKey('statusCode')) {
        final code = json['statusCode'];
        if (code != 200 && code != 201) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            message: json['message'] ?? 'API error occurred ($code)',
          );
        }
      }
    }
    return response;
  }
}
