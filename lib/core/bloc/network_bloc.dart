import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class NetworkEvent {}

class NetworkChanged extends NetworkEvent {
  final List<ConnectivityResult> results;
  NetworkChanged(this.results);
}

// State
class NetworkState {
  final bool isConnected;
  final bool isChecking;

  const NetworkState({
    this.isConnected = true,
    this.isChecking = false,
  });

  NetworkState copyWith({
    bool? isConnected,
    bool? isChecking,
  }) {
    return NetworkState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

// Bloc
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  NetworkBloc() : super(const NetworkState()) {
    on<NetworkChanged>((event, emit) {
      final connected = event.results.isNotEmpty &&
          event.results.any((r) => r != ConnectivityResult.none);
      emit(state.copyWith(isConnected: connected, isChecking: false));
    });

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      add(NetworkChanged(results));
    });

    _checkInitial();
  }

  Future<void> _checkInitial() async {
    final results = await _connectivity.checkConnectivity();
    add(NetworkChanged(results));
  }

  Future<void> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    add(NetworkChanged(results));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
