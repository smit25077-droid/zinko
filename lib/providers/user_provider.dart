import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}

class UserProvider with ChangeNotifier {
  String _membership = 'Free';
  double _balance = 2500.0;
  final List<Transaction> _transactions = [
    Transaction(
        title: 'Initial Deposit',
        date: 'Jan 23, 01:12 PM',
        amount: 3000.0,
        isCredit: true),
    Transaction(
        title: 'Urban Hive Booking',
        date: 'Feb 17, 01:12 PM',
        amount: 500.0,
        isCredit: false),
  ];

  String _name = 'Alex';
  String _email = 'alex@example.com';
  String _phone = '+91 9023256218';
  String _profileImage = 'https://i.pravatar.cc/300';
  String _role = 'Freelancer';
  String _bio = 'Freelance Developer | Coffee Lover';

  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get profileImage => _profileImage;
  String get role => _role;
  String get bio => _bio;

  String get membership => _membership;
  double get balance => _balance;
  List<Transaction> get transactions => _transactions;
  bool get isEmailVerified => _isEmailVerified;
  bool get isPhoneVerified => _isPhoneVerified;
  bool get isPremium =>
      _membership == 'PRO' ||
      _membership == 'ELITE' ||
      _membership == 'Pro' ||
      _membership == 'Elite';

  void setMembership(String plan) {
    _membership = plan;
    notifyListeners();
  }

  void verifyEmail() {
    _isEmailVerified = true;
    notifyListeners();
  }

  void verifyPhone() {
    _isPhoneVerified = true;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String bio,
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _role = role;
    _bio = bio;
    notifyListeners();
  }

  void addMoney(double amount) {
    _balance += amount;
    _transactions.insert(
        0,
        Transaction(
          title: 'Wallet Top-up',
          date: 'Feb 22, 01:38 PM',
          amount: amount,
          isCredit: true,
        ));
    notifyListeners();
  }

  bool redeemReferral(String code) {
    if (code.toLowerCase() == 'smit') {
      _balance += 50.0;
      _transactions.insert(
          0,
          Transaction(
            title: 'Referral Reward',
            date: 'Feb 22, 01:40 PM',
            amount: 50.0,
            isCredit: true,
          ));
      notifyListeners();
      return true;
    }
    return false;
  }
}
