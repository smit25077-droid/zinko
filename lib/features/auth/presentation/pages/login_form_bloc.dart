import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class LoginFormEvent {}
class TogglePasswordVisibility extends LoginFormEvent {}
class SetRememberMe extends LoginFormEvent {
  final bool value;
  SetRememberMe(this.value);
}

// State
class LoginFormState {
  final bool obscurePassword;
  final bool rememberMe;

  LoginFormState({
    this.obscurePassword = true,
    this.rememberMe = false,
  });

  LoginFormState copyWith({
    bool? obscurePassword,
    bool? rememberMe,
  }) {
    return LoginFormState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

// Bloc
class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LoginFormBloc() : super(LoginFormState()) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });
    on<SetRememberMe>((event, emit) {
      emit(state.copyWith(rememberMe: event.value));
    });
  }
}
