import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class WorkspaceDetailEvent {}

class UpdatePageIndex extends WorkspaceDetailEvent {
  final int index;
  UpdatePageIndex(this.index);
}

class AutoScrollImages extends WorkspaceDetailEvent {}

// State
class WorkspaceDetailState {
  final int currentPage;

  const WorkspaceDetailState({this.currentPage = 0});

  WorkspaceDetailState copyWith({int? currentPage}) {
    return WorkspaceDetailState(
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Bloc
class WorkspaceDetailBloc
    extends Bloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  Timer? _timer;

  WorkspaceDetailBloc() : super(const WorkspaceDetailState()) {
    on<UpdatePageIndex>((event, emit) {
      emit(state.copyWith(currentPage: event.index));
    });

    on<AutoScrollImages>((event, emit) {
      final next = (state.currentPage + 1) % 3; // Assuming 3 images for logic
      emit(state.copyWith(currentPage: next));
    });

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(AutoScrollImages());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
