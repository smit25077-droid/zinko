import '../../domain/entities/user_entity.dart';
import 'transaction_model.dart';

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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String,
      membership: json['membership'] as String,
      balance: (json['balance'] as num).toDouble(),
      transactions: (json['transactions'] as List)
          .map((i) => TransactionModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      isEmailVerified: json['isEmailVerified'] as bool,
      isPhoneVerified: json['isPhoneVerified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role,
      'bio': bio,
      'membership': membership,
      'balance': balance,
      'transactions': (transactions as List<TransactionModel>)
          .map((t) => t.toJson())
          .toList(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
    };
  }
}
