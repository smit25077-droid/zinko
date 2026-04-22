import 'package:zinko_app/core/network/api_endpoints.dart';
import 'package:zinko_app/core/network/dio_client.dart';
import 'package:zinko_app/features/auth/data/models/auth_requests.dart';
import 'package:zinko_app/features/auth/data/models/auth_responses.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse<UserData>> login(LoginRequest request);
  Future<AuthResponse<dynamic>> signup(RegisterRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponse<UserData>> login(LoginRequest request) async {
    final response = await client.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return AuthResponse<UserData>.fromJson(
      response.data,
      (data) => UserData.fromJson(data),
    );
  }

  @override
  Future<AuthResponse<dynamic>> signup(RegisterRequest request) async {
    final response = await client.post(
      ApiEndpoints.signup,
      data: request.toJson(),
    );

    return AuthResponse<dynamic>.fromJson(
      response.data,
      (data) => data,
    );
  }
}
