part of 'user_stats_cubit.dart';

@freezed
class UserStatsState with _$UserStatsState {
  const factory UserStatsState.initial() = _Initial;
  const factory UserStatsState.loaded(UserStats userStats) = _Loaded;
  const factory UserStatsState.error(String message) = _Error;
}
