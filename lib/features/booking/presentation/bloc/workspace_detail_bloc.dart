import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class WorkspaceDetailEvent {}

class UpdatePageIndex extends WorkspaceDetailEvent {
  final int index;
  UpdatePageIndex(this.index);
}

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
  WorkspaceDetailBloc() : super(const WorkspaceDetailState()) {
    on<UpdatePageIndex>((event, emit) {
      emit(state.copyWith(currentPage: event.index));
    });
  }
}
