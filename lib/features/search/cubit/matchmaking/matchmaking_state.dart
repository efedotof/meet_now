part of 'matchmaking_cubit.dart';

@freezed
class MatchmakingState with _$MatchmakingState {
  const factory MatchmakingState.initial() = _Initial;
  const factory MatchmakingState.loading() = _Loading;
  const factory MatchmakingState.found({
    required PermanentChatResponseDto permanentChat,
  }) = _Found;
  const factory MatchmakingState.error({required String error}) = _Error;
  const factory MatchmakingState.noResults({required String message}) =
      _NoResults;
}
