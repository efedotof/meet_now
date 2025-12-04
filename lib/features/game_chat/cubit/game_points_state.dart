part of 'game_points_cubit.dart';

@freezed
abstract class GamePointsState with _$GamePointsState {
  const factory GamePointsState.initial() = _Initial;
  const factory GamePointsState.loading() = _Loading;
  const factory GamePointsState.loaded({
    required int points,
    @Default(null) String? lastError,
  }) = _Loaded;
  const factory GamePointsState.refreshing() = _Refreshing;
  const factory GamePointsState.error({required String message}) = _Error;
}
