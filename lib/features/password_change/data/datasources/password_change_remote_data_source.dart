import 'package:zinko_app/core/network/api_endpoints.dart';
import 'package:zinko_app/core/network/dio_client.dart';

abstract class PasswordChangeRemoteDataSource {
  Future<bool> sendOtp(String email);
  Future<int> verifyOtp({required String email, required String otp});
  Future<bool> changePassword({required int userCode, required String password});
}

class PasswordChangeRemoteDataSourceImpl implements PasswordChangeRemoteDataSource {
  final DioClient client;

  PasswordChangeRemoteDataSourceImpl({required this.client});

  @override
  Future<bool> sendOtp(String email) async {
    final response = await client.get(
      '${ApiEndpoints.sendPasswordResetOtp}?email=$email',
    );
    return response.statusCode == 200;
  }

  @override
  Future<int> verifyOtp({required String email, required String otp}) async {
    final response = await client.get(
      '${ApiEndpoints.verifyPasswordResetOtp}?email=$email&otp=$otp',
    );
    if (response.statusCode == 200) {
      return response.data['data']['user_code'];
    }
    throw Exception(response.data['message'] ?? 'Failed to verify OTP');
  }

  @override
  Future<bool> changePassword(
      {required int userCode, required String password}) async {
    final response = await client.post(
      ApiEndpoints.changePassword,
      data: {
        'user_code': userCode,
        'password': password,
      },
    );
    return response.statusCode == 200;
  }
}
