import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/core/di/service_locator.dart';

// Events
abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class ToggleStartupVideo extends SettingsEvent {
  final bool value;
  ToggleStartupVideo(this.value);
}

class TogglePushNotifications extends SettingsEvent {
  final bool value;
  TogglePushNotifications(this.value);
}

// State
class SettingsState {
  final bool showStartupVideo;
  final bool pushNotifications;
  final bool isLoading;

  const SettingsState({
    this.showStartupVideo = true,
    this.pushNotifications = true,
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? showStartupVideo,
    bool? pushNotifications,
    bool? isLoading,
  }) {
    return SettingsState(
      showStartupVideo: showStartupVideo ?? this.showStartupVideo,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences prefs = sl<SharedPreferences>();

  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>((event, emit) {
      emit(state.copyWith(isLoading: true));
      final video = prefs.getBool('show_startup_video') ?? true;
      final notify = prefs.getBool('push_notifications') ?? true;
      emit(state.copyWith(
        showStartupVideo: video,
        pushNotifications: notify,
        isLoading: false,
      ));
    });

    on<ToggleStartupVideo>((event, emit) async {
      await prefs.setBool('show_startup_video', event.value);
      emit(state.copyWith(showStartupVideo: event.value));
    });

    on<TogglePushNotifications>((event, emit) async {
      await prefs.setBool('push_notifications', event.value);
      emit(state.copyWith(pushNotifications: event.value));
    });
  }
}
