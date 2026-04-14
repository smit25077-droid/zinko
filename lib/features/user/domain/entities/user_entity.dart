import 'transaction_entity.dart';

class UserEntity {
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String role;
  final String bio;
  final String membership;
  final double balance;
  final List<TransactionEntity> transactions;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  final int userCode;
  final bool userVisibility;
  final String referralCode;

  final String city;
  final String state;
  final String gender;
  final String birthdate;
  final String companyName;

  const UserEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.role,
    required this.bio,
    required this.membership,
    required this.balance,
    required this.transactions,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.userCode,
    required this.userVisibility,
    required this.referralCode,
    this.city = '',
    this.state = '',
    this.gender = '',
    this.birthdate = '',
    this.companyName = '',
  });

  UserEntity copyWith({
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
    return UserEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      membership: membership ?? this.membership,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
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

  bool get isPremium =>
      membership.toLowerCase() == 'pro' || membership.toLowerCase() == 'elite';

  double get completionPercentage {
    int points = 0;
    if (name.isNotEmpty) points++;
    if (email.isNotEmpty) points++;
    if (phone.isNotEmpty) points++;
    if (profileImage.isNotEmpty) points++;
    if (role.isNotEmpty) points++;
    if (bio.isNotEmpty) points++;
    if (city.isNotEmpty) points++;
    if (state.isNotEmpty) points++;
    if (gender.isNotEmpty) points++;
    if (birthdate.isNotEmpty) points++;
    return points / 10;
  }

  bool get isProfileComplete => completionPercentage >= 1.0;
}
