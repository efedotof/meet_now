import 'dart:async';
import 'dart:developer';

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
    _socketService.messagesStream.listen((messages) {
      log(
        '🔹 Получено ${messages.length} сообщений',
        name: 'MessageRepository',
      );
      _messagesController.add(messages);
    });
    _socketService.singleMessageStream.listen((message) {
      log(
        '🔹 Получено сообщение от ${message.senderId}',
        name: 'MessageRepository',
      );
      _singleMessageController.add(message);
    });
  }

  @override
  Stream<List<Message>> get messagesStream => _messagesController.stream;

  @override
  Stream<Message> get singleMessageStream => _singleMessageController.stream;

  @override
  void requestMessages(String chatId) {
    log('📤 Запрос сообщений для чата $chatId', name: 'MessageRepository');
    _socketService.requestMessages(chatId);
  }

  @override
  void sendMessage(Message message) {
    log('📤 Отправка сообщения: ${message.text}', name: 'MessageRepository');
    _socketService.sendMessage(message);
  }

  @override
  void dispose() {
    log('🛑 Закрытие потоков сообщений', name: 'MessageRepository');
    _messagesController.close();
    _singleMessageController.close();
  }
}
