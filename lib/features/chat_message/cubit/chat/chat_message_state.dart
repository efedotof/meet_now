part of 'chat_message_cubit.dart';

@freezed
abstract class ChatMessageState with _$ChatMessageState {
  const factory ChatMessageState.initial() = _Initial;
  const factory ChatMessageState.loading() = _Loading;
  const factory ChatMessageState.loaded({
    required List<Message> messages,
    @Default(false) bool isLoadingMore,
  }) = _Loaded;
  const factory ChatMessageState.error(String message) = _Error;
}
