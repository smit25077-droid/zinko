import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_workspaces.dart';
import '../../domain/repositories/workspace_repository.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspaces getWorkspaces;
  final WorkspaceRepository repository; // For toggle events

  WorkspaceBloc({
    required this.getWorkspaces,
    required this.repository,
  }) : super(WorkspaceInitial()) {
    on<GetWorkspacesEvent>(_onGetWorkspaces);
    on<ToggleFavoriteWorkspaceEvent>(_onToggleFavorite);
    on<ToggleBookmarkWorkspaceEvent>(_onToggleBookmark);
    on<FilterWorkspacesByCategoryEvent>(_onFilterByCategory);
    on<SearchWorkspacesEvent>(_onSearchWorkspaces);
  }

  void _onSearchWorkspaces(
    SearchWorkspacesEvent event,
    Emitter<WorkspaceState> emit,
  ) {
    if (state is WorkspaceLoaded) {
      emit((state as WorkspaceLoaded).copyWith(searchQuery: event.query));
    }
  }

  Future<void> _onGetWorkspaces(
    GetWorkspacesEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(WorkspaceLoading());
    try {
      final workspaces = await getWorkspaces();
      emit(WorkspaceLoaded(workspaces));
    } catch (e) {
      emit(WorkspaceError(e.toString()));
    }
  }

  void _onFilterByCategory(
    FilterWorkspacesByCategoryEvent event,
    Emitter<WorkspaceState> emit,
  ) {
    if (state is WorkspaceLoaded) {
      emit((state as WorkspaceLoaded).copyWith(selectedCategory: event.category));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    if (state is WorkspaceLoaded) {
      final currentState = state as WorkspaceLoaded;
      await repository.toggleFavorite(event.workspaceId);
      final updatedWorkspaces = await getWorkspaces();
      emit(currentState.copyWith(workspaces: updatedWorkspaces));
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    if (state is WorkspaceLoaded) {
      final currentState = state as WorkspaceLoaded;
      await repository.toggleBookmark(event.workspaceId);
      final updatedWorkspaces = await getWorkspaces();
      emit(currentState.copyWith(workspaces: updatedWorkspaces));
    }
  }
}
