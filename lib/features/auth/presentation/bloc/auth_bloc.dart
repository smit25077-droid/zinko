import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:zinko_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:zinko_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository repository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.repository,
  }) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.request);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (response) => emit(AuthAuthenticated(response.data!)),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUseCase(event.request);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (response) => emit(AuthSuccess(response.message)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await repository.getCachedUser();
    result.fold(
      (_) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(AuthUnauthenticated());
  }
}
