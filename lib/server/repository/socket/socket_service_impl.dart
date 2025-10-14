import 'dart:async';
import 'dart:developer';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/model/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/model/user_activity/user_activity.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/server/service/socket/socket_service.dart';
import 'package:meet_now_app/storage/token/token_interface.dart';
import 'socket_service_interface.dart';

class SocketServiceImpl implements SocketServiceInterface {
  final UserModelAppInterface _userModelAppInterface;
  final TokenInterface _tokenInterface;
  late final SocketService _service;
  SocketServiceImpl({
    required UserModelAppInterface userModelAppInterface,
    required TokenInterface tokenInterface,
  }) : _tokenInterface = tokenInterface,
       _userModelAppInterface = userModelAppInterface;

  final _messagesController = StreamController<List<Message>>.broadcast();
  final _singleMessageController = StreamController<Message>.broadcast();
  final _permanentChatsController =
      StreamController<List<PermanentChatResponseDto>>.broadcast();
  final _temporaryChatsController =
      StreamController<List<TemporaryChat>>.broadcast();
  final _userActivityController = StreamController<UserActivity>.broadcast();
  final _temporaryChatNewController =
      StreamController<TemporaryChat>.broadcast();

  @override
  Stream<List<Message>> get messagesStream => _messagesController.stream;

  @override
  Stream<Message> get singleMessageStream => _singleMessageController.stream;

  @override
  Stream<List<PermanentChatResponseDto>> get permanentChatsStream =>
      _permanentChatsController.stream;

  @override
  Stream<List<TemporaryChat>> get temporaryChatsStream =>
      _temporaryChatsController.stream;

  @override
  Stream<UserActivity> get userActivityStream => _userActivityController.stream;

  @override
  Stream<TemporaryChat> get temporaryChatNewStream =>
      _temporaryChatNewController.stream;

  @override
  void connect() {
    final user = _userModelAppInterface.user;
    final userId = _userModelAppInterface.user!.id;
    if (user == null || userId.isEmpty) {
      log(
        '❌ Пользователь не авторизован или ID пустой',
        name: 'SocketServiceImpl',
      );
      throw Exception('Пользователь не авторизован или ID пустой');
    }

    _service = SocketService(
      userModelAppInterface: _userModelAppInterface,
      tokenInterface: _tokenInterface,
      onMessagesReceived: (List<Message> messages) {
        log(
          '🔹 Получены сообщения: ${messages.length}',
          name: 'SocketServiceImpl',
        );
        _messagesController.add(messages);
      },
      onSingleMessageReceived: (Message message) {
        log(
          '🔹 Получено одно сообщение: ${message.id}',
          name: 'SocketServiceImpl',
        );
        _singleMessageController.add(message);
      },
      onPermanentChatsReceived: (List<PermanentChatResponseDto> chats) {
        log(
          '🔹 Получены постоянные чаты: ${chats.length}',
          name: 'SocketServiceImpl',
        );
        _permanentChatsController.add(chats);
      },
      onTemporaryChatsReceived: (List<TemporaryChat> chats) {
        log(
          '🔹 Получены временные чаты: ${chats.length}',
          name: 'SocketServiceImpl',
        );
        _temporaryChatsController.add(chats);
      },
      onUserActivity: (UserActivity activity) {
        log(
          '🔹 Получена активность пользователя: ${activity.userId}',
          name: 'SocketServiceImpl',
        );
        _userActivityController.add(activity);
      },
      onTemporaryChatNewCallback: (TemporaryChat tempNewChat) {
        log(
          '🔹 Новый временный чат: ${tempNewChat.tempChatId}',
          name: 'SocketServiceImpl',
        );
        _temporaryChatNewController.add(tempNewChat);
      },
    );

    log('✅ Подключение к SocketService выполнено', name: 'SocketServiceImpl');
  }

  @override
  void disconnect() {
    log('⚪ SocketService отключен', name: 'SocketServiceImpl');
    _service.disconnect();
  }

  @override
  void getActiveTemporary() {
    final user = _userModelAppInterface.user;
    final userId = _userModelAppInterface.user!.id;
    if (user == null || userId.isEmpty) {
      log(
        '❌ Пользователь не авторизован или ID пустой',
        name: 'SocketServiceImpl',
      );
      throw Exception('Пользователь не авторизован или ID пустой');
    }
    log('🔹 Запрос активных временных чатов', name: 'SocketServiceImpl');
    _service.getActiveTemporary(userId);
  }

  @override
  void sendActivity(UserActivity activity) {
    log(
      '🔹 Отправка активности пользователя: ${activity.userId}',
      name: 'SocketServiceImpl',
    );
    _service.sendActivity(activity);
  }

  @override
  void getPermanent() {
    final user = _userModelAppInterface.user;
    final userId = _userModelAppInterface.user!.id;
    if (user == null || userId.isEmpty) {
      log(
        '❌ Пользователь не авторизован или ID пустой',
        name: 'SocketServiceImpl',
      );
      throw Exception('Пользователь не авторизован или ID пустой');
    }
    log('🔹 Запрос постоянных чатов', name: 'SocketServiceImpl');
    _service.getPermanent(userId);
  }

  @override
  void requestMessages(String chatId) {
    log('🔹 Запрос сообщений для чата: $chatId', name: 'SocketServiceImpl');
    _service.requestMessages(chatId);
  }

  @override
  void sendMessage(Message message) {
    log('🔹 Отправка сообщения: ${message.id}', name: 'SocketServiceImpl');
    _service.sendMessage(message);
  }

  @override
  void actionSub({required String chatId}) {
    log(
      '🔹 Выполнение действия sub для чата: $chatId',
      name: 'SocketServiceImpl',
    );
    _service.actionSub(chatId: chatId);
  }
}
