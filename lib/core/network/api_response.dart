import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final int statusCode;
  final String message;
  final T? data;
  final String requestId;
  final String timestamp;

  const ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
    required this.requestId,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      requestId: json['requestId'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  @override
  List<Object?> get props => [statusCode, message, data, requestId, timestamp];
}
