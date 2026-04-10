import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_workspaces.dart';
import '../../domain/usecases/search_workspaces.dart';
import '../../domain/repositories/workspace_repository.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspaces getWorkspaces;
  final SearchWorkspaces searchWorkspaces;
  final WorkspaceRepository repository; // For toggle events
  Timer? _debounce;

  WorkspaceBloc({
    required this.getWorkspaces,
    required this.searchWorkspaces,
    required this.repository,
  }) : super(WorkspaceInitial()) {
    on<GetWorkspacesEvent>(_onGetWorkspaces);
    on<ToggleFavoriteWorkspaceEvent>(_onToggleFavorite);
    on<ToggleBookmarkWorkspaceEvent>(_onToggleBookmark);
    on<FilterWorkspacesByCategoryEvent>(_onFilterByCategory);
    on<SearchWorkspacesEvent>(_onSearchWorkspaces);
  }

  Future<void> _onSearchWorkspaces(
    SearchWorkspacesEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    final query = event.query;
    
    // Always update the query in state immediately for UI responsiveness
    if (state is WorkspaceLoaded) {
      emit((state as WorkspaceLoaded).copyWith(searchQuery: query));
    }

    if (query.isNotEmpty && query.length < 3) {
      return;
    }

    _debounce?.cancel();
    
    // Create a completer to handle the async debounce
    final completer = Completer<void>();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      completer.complete();
    });

    await completer.future;

    emit(WorkspaceLoading());
    try {
      final workspaces = await searchWorkspaces(query);
      emit(WorkspaceLoaded(workspaces, searchQuery: query));
    } catch (e) {
      // If fails but was a valid search, we show empty results as requested
      emit(WorkspaceLoaded(const [], searchQuery: query));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
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
      emit((state as WorkspaceLoaded)
          .copyWith(selectedCategory: event.category));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    if (state is WorkspaceLoaded) {
      final currentState = state as WorkspaceLoaded;
      
      // Optimistic Update: Create a new list with the toggled favorite status
      final updatedWorkspaces = currentState.workspaces.map((w) {
        if (w.id == event.workspaceId) {
          // Note: Assuming Entity has a copyWith or we handle it via Casting if it's a model
          // Since we can't be sure about copyWith, and entities should be immutable, 
          // we are assuming the repository update is necessary but we'll emit the changed list first
          return w.copyWith(isFavorite: !w.isFavorite);
        }
        return w;
      }).toList();

      emit(currentState.copyWith(workspaces: updatedWorkspaces));
      
      try {
        await repository.toggleFavorite(event.workspaceId);
      } catch (e) {
        // Rollback on failure (optional but good)
        emit(currentState); 
      }
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    if (state is WorkspaceLoaded) {
      final currentState = state as WorkspaceLoaded;
      
      // Optimistic Update
      final updatedWorkspaces = currentState.workspaces.map((w) {
        if (w.id == event.workspaceId) {
          return w.copyWith(isBookmarked: !w.isBookmarked);
        }
        return w;
      }).toList();

      emit(currentState.copyWith(workspaces: updatedWorkspaces));

      try {
        await repository.toggleBookmark(event.workspaceId);
      } catch (e) {
        emit(currentState);
      }
    }
  }
}
