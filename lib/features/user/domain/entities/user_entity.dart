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
  });

  bool get isPremium =>
      membership.toLowerCase() == 'pro' || membership.toLowerCase() == 'elite';
}
