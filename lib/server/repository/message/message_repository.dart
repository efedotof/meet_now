import 'dart:async';

import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';

class MessageRepository implements MessageInterface {
  final SocketServiceInterface _socketService;
  final StreamController<List<Message>> _messagesController =
      StreamController.broadcast();
  final StreamController<Message> _singleMessageController =
      StreamController.broadcast();

  MessageRepository({required SocketServiceInterface socketService})
    : _socketService = socketService {
    _socketService.messagesStream.listen(_messagesController.add);
    _socketService.singleMessageStream.listen(_singleMessageController.add);
  }

  @override
  Stream<List<Message>> get messagesStream => _messagesController.stream;

  @override
  Stream<Message> get singleMessageStream => _singleMessageController.stream;

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
    _messagesController.close();
    _singleMessageController.close();
  }
}
