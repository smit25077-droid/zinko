import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';

abstract class WorkspaceState extends Equatable {
  const WorkspaceState();

  @override
  List<Object> get props => [];
}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceLoaded extends WorkspaceState {
  final List<WorkspaceEntity> workspaces;
  final String selectedCategory;
  final String searchQuery;
  final int timestamp;

  WorkspaceLoaded(
    this.workspaces, {
    this.selectedCategory = 'All',
    this.searchQuery = '',
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props =>
      [workspaces, selectedCategory, searchQuery, timestamp];

  WorkspaceLoaded copyWith({
    List<WorkspaceEntity>? workspaces,
    String? selectedCategory,
    String? searchQuery,
    int? timestamp,
  }) {
    return WorkspaceLoaded(
      workspaces ?? this.workspaces,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class WorkspaceError extends WorkspaceState {
  final String message;
  const WorkspaceError(this.message);

  @override
  List<Object> get props => [message];
}
