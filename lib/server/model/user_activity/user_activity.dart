import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_activity.freezed.dart';
part 'user_activity.g.dart';

@freezed
abstract class UserActivity with _$UserActivity {
  const factory UserActivity({
    required String userId,
    required String username,
    required String chatId,
    required ActivityType activityType,
    required DateTime timestamp,
  }) = _UserActivity;

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);
}

enum ActivityType {
  TYPING,
  SENDING_IMAGE,
  SENDING_FILE,
  ONLINE,
  OFFLINE;

  factory ActivityType.fromString(String value) =>
      ActivityType.values.firstWhere((e) => e.name == value);
}
