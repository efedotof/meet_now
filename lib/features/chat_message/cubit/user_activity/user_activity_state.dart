part of 'user_activity_cubit.dart';

@freezed
class UserActivityState with _$UserActivityState {
  const factory UserActivityState.initial() = _Initial;
  const factory UserActivityState.activity({required UserActivity activity}) =
      _Activity;
}
