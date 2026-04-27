import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  /// Factory to create a [ServerFailure] from a [DioException].
  /// It extracts the 'message' field from the API response body if available.
  factory ServerFailure.fromDioException(DioException e) {
    String message = 'Server error occurred';

    if (e.response?.data != null && e.response?.data is Map) {
      final json = e.response?.data as Map;
      message = json['message']?.toString() ?? e.message ?? message;
    } else {
      message = e.message ?? message;
    }

    return ServerFailure(message);
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
