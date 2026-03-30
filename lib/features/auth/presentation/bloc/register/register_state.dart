import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final RegisterStatus status;
  final String? errorMessage;

  const RegisterState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.status = RegisterStatus.initial,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    RegisterStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [obscurePassword, obscureConfirmPassword, status, errorMessage];
}
