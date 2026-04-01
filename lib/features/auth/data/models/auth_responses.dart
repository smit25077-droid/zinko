import 'package:equatable/equatable.dart';

class AuthResponse<T> extends Equatable {
  final int statusCode;
  final String message;
  final T? data;
  final String requestId;
  final String timestamp;

  const AuthResponse({
    required this.statusCode,
    required this.message,
    this.data,
    required this.requestId,
    required this.timestamp,
  });

  factory AuthResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return AuthResponse<T>(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null ? fromJsonT(json['data']) : null,
      requestId: json['requestId'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  @override
  List<Object?> get props => [statusCode, message, data, requestId, timestamp];
}

class UserData extends Equatable {
  final String token;
  final String userName;
  final String userType;
  final int userCode;
  final String mobileNo;

  const UserData({
    required this.token,
    required this.userName,
    required this.userType,
    required this.userCode,
    required this.mobileNo,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: json['token'] ?? '',
      userName: json['userName'] ?? '',
      userType: json['userType'] ?? '',
      userCode: json['userCode'] ?? 0,
      mobileNo: json['mobileNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'userName': userName,
        'userType': userType,
        'userCode': userCode,
        'mobileNo': mobileNo,
      };

  @override
  List<Object?> get props => [token, userName, userType, userCode, mobileNo];
}
