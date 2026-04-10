import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class EventSuccessEvent {}

class SetSuccessTransition extends EventSuccessEvent {
  final bool value;
  SetSuccessTransition(this.value);
}

// State
class EventSuccessState {
  final bool isSuccessTransition;

  const EventSuccessState({this.isSuccessTransition = false});

  EventSuccessState copyWith({bool? isSuccessTransition}) {
    return EventSuccessState(
      isSuccessTransition: isSuccessTransition ?? this.isSuccessTransition,
    );
  }
}

// Bloc
class EventSuccessBloc extends Bloc<EventSuccessEvent, EventSuccessState> {
  EventSuccessBloc() : super(const EventSuccessState()) {
    on<SetSuccessTransition>((event, emit) {
      emit(state.copyWith(isSuccessTransition: event.value));
    });
  }
}
