import 'package:equatable/equatable.dart';
import '../../data/models/auth_responses.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserData userData;
  const AuthAuthenticated(this.userData);

  @override
  List<Object?> get props => [userData];
}

class AuthUnauthenticated extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
