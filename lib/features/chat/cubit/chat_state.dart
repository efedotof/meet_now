part of 'chat_cubit.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    required List<Chat> permanentChat,
    required List<TemporaryChat> temporaryChat,
    @Default(false) bool isLoading,
    String? error,
  }) = _ChatState;
}
