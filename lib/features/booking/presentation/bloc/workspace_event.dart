import 'package:equatable/equatable.dart';

abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object> get props => [];
}

class GetWorkspacesEvent extends WorkspaceEvent {}

class ToggleFavoriteWorkspaceEvent extends WorkspaceEvent {
  final String workspaceId;
  const ToggleFavoriteWorkspaceEvent(this.workspaceId);

  @override
  List<Object> get props => [workspaceId];
}

class ToggleBookmarkWorkspaceEvent extends WorkspaceEvent {
  final String workspaceId;
  const ToggleBookmarkWorkspaceEvent(this.workspaceId);

  @override
  List<Object> get props => [workspaceId];
}

class FilterWorkspacesByCategoryEvent extends WorkspaceEvent {
  final String category;
  const FilterWorkspacesByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class SearchWorkspacesEvent extends WorkspaceEvent {
  final String query;
  const SearchWorkspacesEvent(this.query);

  @override
  List<Object> get props => [query];
}
