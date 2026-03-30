import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class GetEventsEvent extends EventEvent {}

class ToggleFavoriteEventEvent extends EventEvent {
  final String id;
  const ToggleFavoriteEventEvent(this.id);

  @override
  List<Object> get props => [id];
}

class RegisterEventEvent extends EventEvent {
  final String id;
  const RegisterEventEvent(this.id);

  @override
  List<Object> get props => [id];
}
