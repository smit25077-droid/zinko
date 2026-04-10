import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class OtpEvent {}

class SetOtpVerifying extends OtpEvent {
  final bool value;
  SetOtpVerifying(this.value);
}

class SetOtpSuccess extends OtpEvent {
  final bool value;
  SetOtpSuccess(this.value);
}

// State
class OtpState {
  final bool isVerifying;
  final bool isSuccess;

  const OtpState({
    this.isVerifying = false,
    this.isSuccess = false,
  });

  OtpState copyWith({
    bool? isVerifying,
    bool? isSuccess,
  }) {
    return OtpState(
      isVerifying: isVerifying ?? this.isVerifying,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// Bloc
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(const OtpState()) {
    on<SetOtpVerifying>((event, emit) {
      emit(state.copyWith(isVerifying: event.value));
    });
    on<SetOtpSuccess>((event, emit) {
      emit(state.copyWith(isSuccess: event.value));
    });
  }
}
