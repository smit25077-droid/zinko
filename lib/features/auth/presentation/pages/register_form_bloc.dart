import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class RegisterFormEvent {}
class TogglePasswordVisibility extends RegisterFormEvent {}
class ToggleConfirmPasswordVisibility extends RegisterFormEvent {}

// State
class RegisterFormState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  RegisterFormState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  RegisterFormState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return RegisterFormState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }
}

// Bloc
class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  RegisterFormBloc() : super(RegisterFormState()) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });
    on<ToggleConfirmPasswordVisibility>((event, emit) {
      emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
    });
  }
}
