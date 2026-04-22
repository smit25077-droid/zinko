import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/booking/domain/usecases/get_workspaces.dart';
import 'package:zinko_app/features/booking/domain/usecases/search_workspaces.dart';
import 'package:zinko_app/features/booking/domain/usecases/watch_workspaces.dart';
import 'package:zinko_app/features/booking/domain/repositories/workspace_repository.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_state.dart';

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
    final result = await searchWorkspaces(query);
    result.fold(
      (failure) => emit(WorkspaceError(failure.message)),
      (workspaces) => emit(WorkspaceLoaded(workspaces, searchQuery: query)),
    );
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
    final result = await getWorkspaces();
    result.fold(
      (failure) => emit(WorkspaceError(failure.message)),
      (workspaces) => emit(WorkspaceLoaded(workspaces)),
    );
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
    final result = await repository.toggleFavorite(event.workspaceId);
    result.fold(
      (failure) => emit(WorkspaceError(failure.message)),
      (_) => null, // Success is handled via the stream listener
    );
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    final result = await repository.toggleBookmark(event.workspaceId);
    result.fold(
      (failure) => debugPrint('Error toggling bookmark: ${failure.message}'),
      (_) => null,
    );
  }
}
