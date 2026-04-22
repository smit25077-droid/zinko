import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapFilterChanged extends MapEvent {
  final String filter;
  const MapFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class MapDataUpdated extends MapEvent {
  final List<WorkspaceEntity> workspaces;
  final List<PersonEntity> people;

  const MapDataUpdated({required this.workspaces, required this.people});

  @override
  List<Object?> get props => [workspaces, people];
}

class GenerateMarkersEvent extends MapEvent {
  final String filter;
  const GenerateMarkersEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SelectWorkspaceEvent extends MapEvent {
  final WorkspaceEntity workspace;
  const SelectWorkspaceEvent(this.workspace);

  @override
  List<Object?> get props => [workspace];
}

class SelectPersonEvent extends MapEvent {
  final PersonEntity person;
  const SelectPersonEvent(this.person);

  @override
  List<Object?> get props => [person];
}

class ClearSelectionEvent extends MapEvent {}
