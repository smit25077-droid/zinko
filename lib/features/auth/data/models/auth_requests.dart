import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String userName;
  final String password;
  final String deviceId;
  final String deviceType;

  const LoginRequest({
    required this.userName,
    required this.password,
    required this.deviceId,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "password": password,
        "device_id": deviceId,
        "device_type": deviceType,
      };

  @override
  List<Object?> get props => [userName, password, deviceId, deviceType];
}

class RegisterRequest extends Equatable {
  final int userCode;
  final String userName;
  final String mobileNo;
  final String emailId;
  final String password;
  final String? referencesReferralCode;

  const RegisterRequest({
    this.userCode = 0,
    required this.userName,
    required this.mobileNo,
    required this.emailId,
    required this.password,
    this.referencesReferralCode,
  });

  Map<String, dynamic> toJson() => {
        "user_code": userCode,
        "user_name": userName,
        "mobile_no": mobileNo,
        "email_id": emailId,
        "password": password,
        "references_referral_code": referencesReferralCode,
      };

  @override
  List<Object?> get props =>
      [userCode, userName, mobileNo, emailId, password, referencesReferralCode];
}
