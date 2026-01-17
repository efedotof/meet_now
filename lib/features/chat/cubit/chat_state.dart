part of 'chat_cubit.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    required List<PermanentChatResponseDto> permanentChat,
    required List<TemporaryChat> temporaryChat,
    @Default(false) bool isLoading,
    String? error,
    String? currentUserId,
    @Default(ChatType.all) ChatType selectedChatType,
    @Default('') String searchQuery,
  }) = _ChatState;
}

enum ChatType { all, permanent, temporary }
