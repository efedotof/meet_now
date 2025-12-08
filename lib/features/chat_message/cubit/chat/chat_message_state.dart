part of 'chat_message_cubit.dart';

@freezed
abstract class ChatMessageState with _$ChatMessageState {
  const factory ChatMessageState.initial() = _Initial;
  const factory ChatMessageState.loading() = _Loading;
  const factory ChatMessageState.loaded({
    required List<Message> messages,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(0) int currentPage,
    required bool isTemporary,
    @Default(false) bool showContinueRequest,
    @Default(false) bool isWaitingForResponse,
    AgreeChatResponse? agreeChatResponse,
  }) = _Loaded;
  const factory ChatMessageState.error(String message) = _Error;
}
