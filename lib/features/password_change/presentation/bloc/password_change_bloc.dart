import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/password_change/domain/usecases/password_change_usecases.dart';

// Events
abstract class PasswordChangeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends PasswordChangeEvent {
  final String email;
  SendOtpEvent(this.email);
  @override
  List<Object?> get props => [email];
}

class VerifyOtpEvent extends PasswordChangeEvent {
  final String email;
  final String otp;
  VerifyOtpEvent({required this.email, required this.otp});
  @override
  List<Object?> get props => [email, otp];
}

class ResetPasswordSubmittedEvent extends PasswordChangeEvent {
  final int userCode;
  final String password;
  ResetPasswordSubmittedEvent({required this.userCode, required this.password});
  @override
  List<Object?> get props => [userCode, password];
}

class TogglePasswordVisibilityEvent extends PasswordChangeEvent {}
class ToggleConfirmPasswordVisibilityEvent extends PasswordChangeEvent {}

// States
class PasswordChangeState extends Equatable {
  final int currentStep;
  final String? email;
  final int? userCode;
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  const PasswordChangeState({
    this.currentStep = 1,
    this.email,
    this.userCode,
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  PasswordChangeState copyWith({
    int? currentStep,
    String? email,
    int? userCode,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return PasswordChangeState(
      currentStep: currentStep ?? this.currentStep,
      email: email ?? this.email,
      userCode: userCode ?? this.userCode,
      isLoading: isLoading ?? this.isLoading,
      error: error, // We want to be able to nullify error
      successMessage: successMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        email,
        userCode,
        isLoading,
        error,
        successMessage,
        obscurePassword,
        obscureConfirmPassword,
      ];
}

// BLoC
class PasswordChangeBloc extends Bloc<PasswordChangeEvent, PasswordChangeState> {
  final SendPasswordResetOtp sendOtpUseCase;
  final VerifyPasswordResetOtp verifyOtpUseCase;
  final ResetPassword resetPasswordUseCase;

  PasswordChangeBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  }) : super(const PasswordChangeState()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordSubmittedEvent>(_onResetPassword);
    on<TogglePasswordVisibilityEvent>((event, emit) => emit(state.copyWith(obscurePassword: !state.obscurePassword)));
    on<ToggleConfirmPasswordVisibilityEvent>((event, emit) => emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword)));
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<PasswordChangeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await sendOtpUseCase(event.email);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (success) => emit(state.copyWith(isLoading: false, currentStep: 2, email: event.email)),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<PasswordChangeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await verifyOtpUseCase(VerifyOtpParams(email: event.email, otp: event.otp));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (userCode) => emit(state.copyWith(isLoading: false, currentStep: 3, userCode: userCode)),
    );
  }

  Future<void> _onResetPassword(ResetPasswordSubmittedEvent event, Emitter<PasswordChangeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await resetPasswordUseCase(ResetPasswordParams(userCode: event.userCode, password: event.password));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (success) => emit(state.copyWith(isLoading: false, successMessage: "Password Change Successfully")),
    );
  }
}
