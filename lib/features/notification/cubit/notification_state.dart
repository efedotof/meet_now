part of 'notification_cubit.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = _Initial;
  const factory NotificationState.loading() = _Loading;
  const factory NotificationState.loaded({
    required bool enableNotifications,
    required bool enableSound,
    required bool enableVibration,
    required bool enableBadge,
    required bool enablePreviews,
    required bool quietHoursEnabled,
    required bool silentMode,
    required bool messageNotifications,
    required bool friendRequestNotifications,
    required bool systemNotifications,
  }) = _Loaded;
  const factory NotificationState.error(String message) = _Error;
}
