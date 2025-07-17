import 'dart:async';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';
import 'package:meet_now_app/server/service/socket_service.dart';

class MessageRepository implements MessageInterface {
  late final SocketService _socketService;

  final _messageStreamController = StreamController<List<Message>>.broadcast();
  final _incomingMessageController = StreamController<Message>.broadcast();
  @override
  Stream<List<Message>> get messagesStream => _messageStreamController.stream;
  @override
  Stream<Message> get incomingMessageStream =>
      _incomingMessageController.stream;

  // @override
  // void init(String userId) {
  //   _socketService = SocketService(
  //     userId: userId,
  //     onMessagesReceived: (messages) => _messageStreamController.add(messages),
  //     onSingleMessageReceived: (msg) => _incomingMessageController.add(msg),
  //   );
  //   _socketService.connect();
  // }

  @override
  void requestMessages(String chatId) {
    _socketService.requestMessages(chatId);
  }

  @override
  void sendMessage(Message message) {
    _socketService.sendMessage(message);
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _messageStreamController.close();
    _incomingMessageController.close();
  }
}
