part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.getChats({
    required List<TemporaryChat> temporaryChat,
    required List<Chat> permomentChat,
  }) = _GetChats;
}
