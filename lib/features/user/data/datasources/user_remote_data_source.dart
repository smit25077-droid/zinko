import 'package:zinko_app/features/user/data/models/transaction_model.dart';

import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String bio,
    String? profileImage,
    String? membership,
    bool? isEmailVerified,
    bool? isPhoneVerified,
  });
  Future<UserModel> addMoney(double amount);
  Future<UserModel> redeemReferral(String code);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // Since we don't have a real API yet, we'll implement a mock version
  // that returns the same structure as the existing UserProvider.

  UserModel _mockUser = UserModel(
    name: 'Alex',
    email: 'alex@example.com',
    phone: '+91 9023256218',
    profileImage: 'https://i.pravatar.cc/300',
    role: 'Freelancer',
    bio: 'Freelance Developer | Coffee Lover',
    membership: 'Free',
    balance: 2500.0,
    transactions: [
      TransactionModel(
          title: 'Initial Deposit',
          date: 'Jan 23, 01:12 PM',
          amount: 3000.0,
          isCredit: true),
      TransactionModel(
          title: 'Urban Hive Booking',
          date: 'Feb 17, 01:12 PM',
          amount: 500.0,
          isCredit: false),
    ],
    isEmailVerified: false,
    isPhoneVerified: false,
  );

  @override
  Future<UserModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockUser;
  }

  @override
  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String bio,
    String? profileImage,
    String? membership,
    bool? isEmailVerified,
    bool? isPhoneVerified,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockUser = UserModel(
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage ?? _mockUser.profileImage,
      role: role,
      bio: bio,
      membership: membership ?? _mockUser.membership,
      balance: _mockUser.balance,
      transactions: _mockUser.transactions as List<TransactionModel>,
      isEmailVerified: isEmailVerified ?? _mockUser.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? _mockUser.isPhoneVerified,
    );
    return _mockUser;
  }

  @override
  Future<UserModel> addMoney(double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newTransactions = List<TransactionModel>.from(_mockUser.transactions)
      ..insert(
        0,
        TransactionModel(
          title: 'Wallet Top-up',
          date: 'Feb 22, 01:38 PM',
          amount: amount,
          isCredit: true,
        ),
      );
    _mockUser = UserModel(
      name: _mockUser.name,
      email: _mockUser.email,
      phone: _mockUser.phone,
      profileImage: _mockUser.profileImage,
      role: _mockUser.role,
      bio: _mockUser.bio,
      membership: _mockUser.membership,
      balance: _mockUser.balance + amount,
      transactions: newTransactions,
      isEmailVerified: _mockUser.isEmailVerified,
      isPhoneVerified: _mockUser.isPhoneVerified,
    );
    return _mockUser;
  }

  @override
  Future<UserModel> redeemReferral(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (code.toLowerCase() == 'smit') {
      final newTransactions =
          List<TransactionModel>.from(_mockUser.transactions)
            ..insert(
              0,
              TransactionModel(
                title: 'Referral Reward',
                date: 'Feb 22, 01:40 PM',
                amount: 50.0,
                isCredit: true,
              ),
            );
      _mockUser = UserModel(
        name: _mockUser.name,
        email: _mockUser.email,
        phone: _mockUser.phone,
        profileImage: _mockUser.profileImage,
        role: _mockUser.role,
        bio: _mockUser.bio,
        membership: _mockUser.membership,
        balance: _mockUser.balance + 50.0,
        transactions: newTransactions,
        isEmailVerified: _mockUser.isEmailVerified,
        isPhoneVerified: _mockUser.isPhoneVerified,
      );
      return _mockUser;
    }
    throw Exception('Invalid referral code');
  }
}
