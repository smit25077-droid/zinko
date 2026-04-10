import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class SplashEvent {}

class SetSplashInitialized extends SplashEvent {
  final bool value;
  SetSplashInitialized(this.value);
}

class SetSplashVideoFinished extends SplashEvent {
  final bool value;
  SetSplashVideoFinished(this.value);
}

// State
class SplashState {
  final bool isInitialized;
  final bool videoFinished;

  const SplashState({
    this.isInitialized = false,
    this.videoFinished = false,
  });

  SplashState copyWith({
    bool? isInitialized,
    bool? videoFinished,
  }) {
    return SplashState(
      isInitialized: isInitialized ?? this.isInitialized,
      videoFinished: videoFinished ?? this.videoFinished,
    );
  }
}

// Bloc
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<SetSplashInitialized>((event, emit) {
      emit(state.copyWith(isInitialized: event.value));
    });
    on<SetSplashVideoFinished>((event, emit) {
      emit(state.copyWith(videoFinished: event.value));
    });
  }
}
