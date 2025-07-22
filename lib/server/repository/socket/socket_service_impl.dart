import "dart:async";
import "package:meet_now_app/server/model/chat/chat.dart";
import "package:meet_now_app/server/model/message/message.dart";
import "package:meet_now_app/server/model/temporary/temporary_chat.dart";
import "package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart";
import "package:meet_now_app/server/service/socket_service.dart";

import "socket_service_interface.dart";

class SocketServiceImpl implements SocketServiceInterface {
  final UserModelAppInterface _userModelAppInterface;
  late final SocketService _service;
  SocketServiceImpl({required UserModelAppInterface userModelAppInterface})
    : _userModelAppInterface = userModelAppInterface;

  final _messagesController = StreamController<List<Message>>.broadcast();
  final _singleMessageController = StreamController<Message>.broadcast();
  final _permanentChatsController = StreamController<List<Chat>>.broadcast();
  final _temporaryChatsController =
      StreamController<List<TemporaryChat>>.broadcast();

  @override
  Stream<List<Message>> get messagesStream => _messagesController.stream;

  @override
  Stream<Message> get singleMessageStream => _singleMessageController.stream;

  @override
  Stream<List<Chat>> get permanentChatsStream =>
      _permanentChatsController.stream;

  @override
  Stream<List<TemporaryChat>> get temporaryChatsStream =>
      _temporaryChatsController.stream;

  @override
  void connect() {
    final user = _userModelAppInterface.user;
    final userId = _userModelAppInterface.user!.id;
    if (user == null || userId.isEmpty) {
      throw Exception('Пользователь не авторизован или ID пустой');
    }

    _service = SocketService(
      userModelAppInterface: _userModelAppInterface,
      onMessagesReceived: (List<Message> messages) {
        _messagesController.add(messages);
      },
      onSingleMessageReceived: (Message message) {
        _singleMessageController.add(message);
      },
      onPermanentChatsReceived: (List<Chat> chats) {
        _permanentChatsController.add(chats);
      },
      onTemporaryChatsReceived: (List<TemporaryChat> chats) {
        _temporaryChatsController.add(chats);
      },
    );
  }

  @override
  void disconnect() {
    _service.disconnect();
  }

  @override
  void getActiveTemporary() {
    final user = _userModelAppInterface.user;
    final userId = _userModelAppInterface.user!.id;
    if (user == null || userId.isEmpty) {
      throw Exception('Пользователь не авторизован или ID пустой');
    }
    _service.getActiveTemporary(userId);
  }

  @override
  void getPermanent() {
    final user = _userModelAppInterface.user;
    final userId = _userModelAppInterface.user!.id;
    if (user == null || userId.isEmpty) {
      throw Exception('Пользователь не авторизован или ID пустой');
    }
    _service.getPermanent(userId);
  }

  @override
  void requestMessages(String chatId) {
    _service.requestMessages(chatId);
  }

  @override
  void sendMessage(Message message) {
    _service.sendMessage(message);
  }
}
