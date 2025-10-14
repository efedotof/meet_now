part of 'game_chat_cubit.dart';

@freezed
abstract class GameChatState with _$GameChatState {
  const factory GameChatState.initial() = _Initial;
  const factory GameChatState.loading() = _Loading;
  const factory GameChatState.loaded({required List<GameResponse> games}) =
      _Loaded;
  const factory GameChatState.error({required String message}) = _Error;
}
