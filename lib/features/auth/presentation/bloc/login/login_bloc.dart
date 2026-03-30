import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;

  LoginBloc({
    required this.login,
  }) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ToggleRememberMe>(_onToggleRememberMe);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await login(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: LoginStatus.success)),
    );
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleRememberMe(
    ToggleRememberMe event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(rememberMe: event.rememberMe));
  }
}

