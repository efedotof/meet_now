import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';

abstract interface class SocketServiceInterface {
  void connect();
  void disconnect();
  void requestMessages(String chatId);
  void sendMessage(Message message);
  void getActiveTemporary();
  void getPermanent();

  Stream<List<Message>> get messagesStream;
  Stream<Message> get singleMessageStream;
  Stream<List<Chat>> get permanentChatsStream;
  Stream<List<TemporaryChat>> get temporaryChatsStream;
}
