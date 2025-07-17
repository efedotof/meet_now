part of 'chat_message_cubit.dart';

@freezed
class ChatMessageState with _$ChatMessageState {
  const factory ChatMessageState.initial() = _Initial;
  const factory ChatMessageState.loaded({required List<Message> messages}) =
      _Loaded;
}
