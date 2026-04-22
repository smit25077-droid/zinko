import 'package:zinko_app/features/user/domain/entities/user_entity.dart';
import 'package:zinko_app/features/user/domain/entities/transaction_entity.dart';
import 'package:zinko_app/features/user/data/models/transaction_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.profileImage,
    required super.role,
    required super.bio,
    required super.membership,
    required super.balance,
    required List<TransactionModel> super.transactions,
    required super.isEmailVerified,
    required super.isPhoneVerified,
    required super.userCode,
    required super.userVisibility,
    required super.referralCode,
    super.city = '',
    super.state = '',
    super.gender = '',
    super.birthdate = '',
    super.companyName = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userCode: json['user_code'] ?? (json['userCode'] ?? 0),
      name:
          json['user_name'] ?? (json['full_name'] ?? (json['userName'] ?? '')),
      email: json['email_id'] ?? (json['email'] ?? ''),
      phone: json['mobile_no'] ?? (json['mobileNo'] ?? ''),
      profileImage: (json['profile_photo_url'] ??
              (json['profile_photo'] ?? 'https://i.pravatar.cc/300'))
          .toString()
          .replaceAll(RegExp(r'http://localhost:\d+'), 'http://187.127.135.213:8090'),
      role: json['user_type'] ??
          (json['profession'] ?? (json['userType'] ?? 'Member')),
      bio: json['bio'] ?? (json['profile_bio'] ?? ''),
      membership: json['membership'] ?? 'Free',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      transactions: (json['transactions'] as List?)
              ?.map((i) => TransactionModel.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      isEmailVerified:
          json['email_verify'] ?? (json['email_verified'] ?? false),
      isPhoneVerified:
          json['phone_verify'] ?? (json['phone_verified'] ?? false),
      userVisibility: json['user_visibility'] ?? (json['visibility'] ?? false),
      referralCode: json['referral_code'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      gender: json['gender'] ?? '',
      birthdate: json['birthdate'] ?? '',
      companyName: json['company_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_code': userCode,
      'user_name': name,
      'email_id': email,
      'mobile_no': phone,
      'profile_photo_url': profileImage,
      'user_type': role,
      'bio': bio,
      'membership': membership,
      'balance': balance,
      'transactions': (transactions as List<TransactionModel>)
          .map((t) => t.toJson())
          .toList(),
      'email_verify': isEmailVerified,
      'phone_verify': isPhoneVerified,
      'user_visibility': userVisibility,
      'referral_code': referralCode,
      'city': city,
      'state': state,
      'gender': gender,
      'birthdate': birthdate,
      'company_name': companyName,
    };
  }

  @override
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? role,
    String? bio,
    String? membership,
    double? balance,
    List<TransactionEntity>? transactions,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    int? userCode,
    bool? userVisibility,
    String? referralCode,
    String? city,
    String? state,
    String? gender,
    String? birthdate,
    String? companyName,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      membership: membership ?? this.membership,
      balance: balance ?? this.balance,
      transactions: transactions != null
          ? transactions.cast<TransactionModel>()
          : this.transactions as List<TransactionModel>,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      userCode: userCode ?? this.userCode,
      userVisibility: userVisibility ?? this.userVisibility,
      referralCode: referralCode ?? this.referralCode,
      city: city ?? this.city,
      state: state ?? this.state,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      companyName: companyName ?? this.companyName,
    );
  }
}
