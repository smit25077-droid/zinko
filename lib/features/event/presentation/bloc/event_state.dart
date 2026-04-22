import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/event/domain/entities/event_entity.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<EventEntity> events;
  const EventLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class EventError extends EventState {
  final String message;
  const EventError(this.message);

  @override
  List<Object> get props => [message];
}

class EventRegistrationSuccess extends EventLoaded {
  final String eventName;
  const EventRegistrationSuccess(this.eventName, {required super.events});

  @override
  List<Object> get props => [eventName, events];
}
