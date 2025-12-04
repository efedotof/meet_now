import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/storage/notification/notification_settings_interface.dart';

part 'notification_state.dart';
part 'notification_cubit.freezed.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationSettingsInterface _notificationSettingsRepository;

  NotificationCubit({
    required NotificationSettingsInterface notificationSettingsRepository,
  }) : _notificationSettingsRepository = notificationSettingsRepository,
       super(NotificationState.initial());

  Future<void> loadSettings() async {
    try {
      emit(NotificationState.loading());

      final settings = await _notificationSettingsRepository.getAllSettings();

      emit(
        NotificationState.loaded(
          enableNotifications: settings['enable_notifications'] ?? true,
          enableSound: settings['enable_sound'] ?? true,
          enableVibration: settings['enable_vibration'] ?? true,
          enableBadge: settings['enable_badge'] ?? true,
          enablePreviews: settings['enable_previews'] ?? true,
          quietHoursEnabled: settings['quiet_hours_enabled'] ?? false,
          silentMode: settings['silent_mode'] ?? false,
          messageNotifications: settings['action_open_chat'] ?? true,
          friendRequestNotifications:
              settings['action_view_friend_requests'] ?? true,
          systemNotifications: settings['action_system_notification'] ?? true,
        ),
      );
    } catch (e) {
      emit(NotificationState.error(e.toString()));
    }
  }

  Future<void> toggleSetting(String key, bool value) async {
    final currentState = state;

    if (currentState is _Loaded) {
      try {
        await _notificationSettingsRepository.saveGeneralSetting(key, value);

        final newSettings = currentState.copyWith(
          enableNotifications:
              key == 'enable_notifications'
                  ? value
                  : currentState.enableNotifications,
          enableSound: key == 'enable_sound' ? value : currentState.enableSound,
          enableVibration:
              key == 'enable_vibration' ? value : currentState.enableVibration,
          enableBadge: key == 'enable_badge' ? value : currentState.enableBadge,
          enablePreviews:
              key == 'enable_previews' ? value : currentState.enablePreviews,
          quietHoursEnabled:
              key == 'quiet_hours_enabled'
                  ? value
                  : currentState.quietHoursEnabled,
          silentMode: key == 'silent_mode' ? value : currentState.silentMode,
        );

        emit(newSettings);
      } catch (e) {
        emit(NotificationState.error(e.toString()));
      }
    }
  }

  Future<void> toggleActionSetting(String action, bool value) async {
    final currentState = state;

    if (currentState is _Loaded) {
      try {
        await _notificationSettingsRepository.saveActionSetting(action, value);

        final newSettings = currentState.copyWith(
          messageNotifications:
              action == 'open_chat' ? value : currentState.messageNotifications,
          friendRequestNotifications:
              action == 'view_friend_requests'
                  ? value
                  : currentState.friendRequestNotifications,
          systemNotifications:
              action == 'system_notification'
                  ? value
                  : currentState.systemNotifications,
        );

        emit(newSettings);
      } catch (e) {
        emit(NotificationState.error(e.toString()));
      }
    }
  }

  Future<void> resetToDefaults() async {
    try {
      await _notificationSettingsRepository.resetToDefaults();
      await loadSettings();
    } catch (e) {
      emit(NotificationState.error(e.toString()));
    }
  }
}
