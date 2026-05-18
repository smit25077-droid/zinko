import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/utils/network_error_handler.dart';

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
    return ServerFailure(NetworkErrorHandler.getErrorMessage(e));
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
