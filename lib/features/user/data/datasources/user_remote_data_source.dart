import 'package:zinko_app/core/network/api_endpoints.dart';
import 'package:zinko_app/core/network/dio_client.dart';
import 'package:zinko_app/features/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile();

  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String bio,
    required int userCode,
    String? profileImage,
    String? membership,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? city,
    String? state,
    String? gender,
    String? birthdate,
    String? companyName,
  });

  Future<UserModel> addMoney(double amount);

  Future<UserModel> redeemReferral(String code);

  Future<bool> updateVisibility(bool visibility);

  Future<bool> sendEmailOtp(String email);

  Future<bool> verifyEmailOtp({
    required String userCode,
    required String otp,
  });

  Future<bool> deleteUser(int userCode);
  Future<bool> changePassword({required int userCode, required String password});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getUserProfile() async {
    final response = await client.get(
      ApiEndpoints.userProfile,
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to load user profile');
  }

  @override
  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String bio,
    required int userCode,
    String? profileImage,
    String? membership,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? city,
    String? state,
    String? gender,
    String? birthdate,
    String? companyName,
  }) async {
    final response = await client.post('user/profile/update', data: {
      'user_code': userCode,
      'city': city,
      'state': state,
      'gender': gender,
      'birthdate': birthdate,
      'profession': role,
      'company_name': companyName,
      'profile_bio': bio,
      'full_name': name,
    });

    if (response.statusCode == 200) {
      // Re-fetch profile to get updated totals/states
      // return await getUserProfile();
    }
    throw Exception('Failed to update profile');
  }

  @override
  Future<UserModel> addMoney(double amount) async {
    final response =
        await client.post('/api/user/wallet/add', data: {'amount': amount});
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    }
    return await getUserProfile();
  }

  @override
  Future<UserModel> redeemReferral(String code) async {
    final response =
        await client.post('/api/user/redeem-referral', data: {'code': code});
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    }
    throw Exception('Invalid referral code');
  }

  @override
  Future<bool> updateVisibility(bool visibility) async {
    final response = await client.post(
      ApiEndpoints.userVisibility,
    );
    if (response.statusCode == 200) {
      return response.data['data']['user_visibility'] as bool;
    }
    throw Exception('Failed to update visibility');
  }

  @override
  Future<bool> sendEmailOtp(String email) async {
    final response = await client.get(
      '${ApiEndpoints.sendEmailOtp}?email=$email',
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(response.data['message'] ?? 'Failed to send OTP');
  }

  @override
  Future<bool> verifyEmailOtp({
    required String userCode,
    required String otp,
  }) async {
    final response = await client.get(
      '${ApiEndpoints.verifyEmailOtp}?user_code=$userCode&otp=$otp',
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(response.data['message'] ?? 'Failed to verify OTP');
  }

  @override
  Future<bool> deleteUser(int userCode) async {
    final response = await client.post(
      ApiEndpoints.deleteUser,
      data: {'user_code': userCode},
    );
    return response.statusCode == 200;
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
