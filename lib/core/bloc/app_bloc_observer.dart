import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Log state transitions that look like errors
    final nextState = change.nextState.toString().toLowerCase();
    if (nextState.contains('error') || nextState.contains('failure')) {
      log('Bloc: ${bloc.runtimeType}, State Change: ${change.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('Bloc Error in ${bloc.runtimeType}:');
    log('Error: $error');
    log('StackTrace: $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // You can also log transitions here if needed
  }
}
