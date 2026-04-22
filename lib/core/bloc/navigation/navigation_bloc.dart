import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_event.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigationTabChanged>((event, emit) {
      emit(NavigationState(index: event.index));
    });
  }
}
