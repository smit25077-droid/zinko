import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/event_usecases.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEvents getEvents;
  final ToggleFavoriteEvent toggleFavoriteEvent;
  final RegisterEvent registerEvent;

  EventBloc({
    required this.getEvents,
    required this.toggleFavoriteEvent,
    required this.registerEvent,
  }) : super(EventInitial()) {
    on<GetEventsEvent>(_onGetEvents);
    on<ToggleFavoriteEventEvent>(_onToggleFavorite);
    on<RegisterEventEvent>(_onRegisterEvent);
  }

  Future<void> _onGetEvents(
      GetEventsEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    final result = await getEvents(NoParams());
    result.fold(
      (failure) => emit(EventError(failure.message)),
      (events) => emit(EventLoaded(events: events)),
    );
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEventEvent event, Emitter<EventState> emit) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;
      final result = await toggleFavoriteEvent(event.id);
      result.fold(
        (failure) => emit(EventError(failure.message)),
        (updatedEvent) {
          final updatedEvents = currentState.events.map((e) {
            return e.id == updatedEvent.id ? updatedEvent : e;
          }).toList();
          emit(EventLoaded(events: updatedEvents));
        },
      );
    }
  }

  Future<void> _onRegisterEvent(
      RegisterEventEvent event, Emitter<EventState> emit) async {
    if (state is EventLoaded) {
      final currentState = state as EventLoaded;
      final result = await registerEvent(event.id);
      result.fold(
        (failure) => emit(EventError(failure.message)),
        (updatedEvent) {
          final updatedEvents = currentState.events.map((e) {
            return e.id == updatedEvent.id ? updatedEvent : e;
          }).toList();
          emit(EventRegistrationSuccess(updatedEvent.title,
              events: updatedEvents));
        },
      );
    }
  }
}
