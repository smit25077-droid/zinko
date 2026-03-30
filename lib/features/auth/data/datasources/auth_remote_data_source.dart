import 'package:dartz/dartz.dart';

abstract class AuthRemoteDataSource {
  /// Since the backend isn't wired yet, this returns a mocked result.
  Future<Unit> login({
    required String email,
    required String password,
  });

  Future<Unit> register({
    required String name,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Unit> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 650));

    final normalizedEmail = email.trim().toLowerCase();

    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizedEmail);
    final passwordOk = password.trim().length >= 6;

    if (!emailOk) {
      throw Exception('Please enter a valid email address.');
    }
    if (!passwordOk) {
      throw Exception('Password must be at least 6 characters.');
    }

    return unit;
  }

  @override
  Future<Unit> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (name.trim().isEmpty) {
      throw Exception('Name is required.');
    }

    final normalizedEmail = email.trim().toLowerCase();
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizedEmail);
    final passwordOk = password.trim().length >= 6;

    if (!emailOk) {
      throw Exception('Please enter a valid email address.');
    }
    if (!passwordOk) {
      throw Exception('Password must be at least 6 characters.');
    }

    return unit;
  }
}

