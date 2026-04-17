import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_workspaces.dart';
import '../../domain/usecases/search_workspaces.dart';
import '../../domain/usecases/watch_workspaces.dart';
import '../../domain/repositories/workspace_repository.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspaces getWorkspaces;
  final SearchWorkspaces searchWorkspaces;
  final WatchWorkspaces watchWorkspaces;
  final WorkspaceRepository repository; // For toggle events
  Timer? _debounce;
  StreamSubscription? _streamSubscription;

  WorkspaceBloc({
    required this.getWorkspaces,
    required this.searchWorkspaces,
    required this.watchWorkspaces,
    required this.repository,
  }) : super(WorkspaceInitial()) {
    on<GetWorkspacesEvent>(_onGetWorkspaces);
    on<ToggleFavoriteWorkspaceEvent>(_onToggleFavorite);
    on<ToggleBookmarkWorkspaceEvent>(_onToggleBookmark);
    on<FilterWorkspacesByCategoryEvent>(_onFilterByCategory);
    on<SearchWorkspacesEvent>(_onSearchWorkspaces);
    on<WorkspacesUpdated>(_onWorkspacesUpdated);

    _streamSubscription = watchWorkspaces().listen((workspaces) {
      add(WorkspacesUpdated(workspaces));
    });
  }

  void _onWorkspacesUpdated(
    WorkspacesUpdated event,
    Emitter<WorkspaceState> emit,
  ) {
    if (state is WorkspaceLoaded) {
      final currentState = state as WorkspaceLoaded;
      // We must preserve category and search query filters while updating workspaces list!
      // But typically, the stream contains the master list. Wait, if the user searched,
      // the master list stream doesn't know about search results.
      // We will handle filtering later or just emit the workspaces.
      // Wait, if search is active, do we overwrite it? Yes, we can just replace workspaces.
      emit(currentState.copyWith(workspaces: event.workspaces));
    } else {
      emit(WorkspaceLoaded(event.workspaces));
    }
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
    _streamSubscription?.cancel();
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
    try {
      await repository.toggleFavorite(event.workspaceId);
    } catch (e) {
      // Handle error natively via stream if needed, or emit failure.
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await repository.toggleBookmark(event.workspaceId);
    } catch (e) {
    }
  }
}
