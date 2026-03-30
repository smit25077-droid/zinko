import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Register register;

  RegisterBloc({required this.register}) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<ToggleRegisterPasswordVisibility>(_onToggleRegisterPasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    final result = await register(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: RegisterStatus.success)),
    );
  }

  void _onToggleRegisterPasswordVisibility(
    ToggleRegisterPasswordVisibility event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibility event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }
}
