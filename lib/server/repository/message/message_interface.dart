import 'package:meet_now_app/server/model/message/message.dart';

abstract interface class MessageInterface {
  // void init(String userId);
  void requestMessages(String chatId);
  void sendMessage(Message message);
  void dispose();
  Stream<List<Message>> get messagesStream;
  Stream<Message> get incomingMessageStream;
}
