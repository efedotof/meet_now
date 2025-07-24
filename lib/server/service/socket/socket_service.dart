import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/model/user_activity/user_activity.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

typedef MessageCallback = void Function(List<Message> messages);
typedef SingleMessageCallback = void Function(Message message);
typedef ChatListCallback = void Function(List<Chat> chats);
typedef TemporaryChatListCallback = void Function(List<TemporaryChat> chats);
typedef UserActivityCallback = void Function(UserActivity activity);

class SocketService {
  late final StompClient _stompClient;
  final UserModelAppInterface userModelAppInterface;

  final MessageCallback? onMessagesReceived;
  final SingleMessageCallback? onSingleMessageReceived;
  final ChatListCallback? onPermanentChatsReceived;
  final TemporaryChatListCallback? onTemporaryChatsReceived;
  final UserActivityCallback? onUserActivity;

  bool _isConnected = false;
  final List<void Function()> _pendingActions = [];

  SocketService({
    required this.userModelAppInterface,
    required this.onMessagesReceived,
    required this.onSingleMessageReceived,
    required this.onPermanentChatsReceived,
    required this.onTemporaryChatsReceived,
    required this.onUserActivity,
  }) {
    connect();
  }

  void connect() {
    final user = userModelAppInterface.user;
    final userId = user?.id;
    final token = user?.token;

    if (user == null || userId == null || token == null || token.isEmpty) {
      throw Exception('Пользователь не авторизован или данные неполные');
    }

    debugPrint('[SocketService] Connecting...');

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: socketAddress,
        onConnect: _onConnect,
        onDisconnect: (frame) {
          debugPrint('[SocketService] Disconnected: ${frame.body}');
          _isConnected = false;
        },
        onWebSocketError:
            (error) => debugPrint('[SocketService] WebSocket Error: $error'),
        onStompError:
            (frame) => debugPrint('[SocketService] STOMP Error: ${frame.body}'),
        onUnhandledMessage:
            (frame) =>
                debugPrint('[SocketService] Unhandled message: ${frame.body}'),
        onUnhandledReceipt:
            (frame) =>
                debugPrint('[SocketService] Unhandled receipt: ${frame.body}'),
        onUnhandledFrame:
            (frame) =>
                debugPrint('[SocketService] Unhandled frame: ${frame.body}'),
        onDebugMessage: (msg) => debugPrint('[SocketService] Debug: $msg'),
        onWebSocketDone: () {
          debugPrint('[SocketService] WebSocket connection closed.');
          _isConnected = false;
        },
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    debugPrint('[SocketService] Connected');
    _isConnected = true;

    _subscribe('/user/queue/messages', (frame) {
      final data = json.decode(frame.body!);
      final message = Message.fromJson(data);
      onSingleMessageReceived?.call(message);
    });

    _subscribe('/user/queue/chat.permanent', (frame) {
      final raw = json.decode(frame.body!) as List;
      final chats = raw.map((e) => Chat.fromJson(e)).toList();
      onPermanentChatsReceived?.call(chats);
    });

    _subscribe('/user/queue/chat.temporary.active', (frame) {
      final raw = json.decode(frame.body!) as List;
      final chats = raw.map((e) => TemporaryChat.fromJson(e)).toList();
      onTemporaryChatsReceived?.call(chats);
    });

    _subscribe('/user/queue/chat.messages', (frame) {
      final raw = json.decode(frame.body!) as List;
      debugPrint("Пришло сообщение в чате: $raw");
    });

    for (final action in _pendingActions) {
      action();
    }
    _pendingActions.clear();
  }

  void requestMessages(String chatId) {
    _enqueueOrRun(() {
      debugPrint("requestMessages: $chatId");
      _subscribe('/user/queue/chat.messages', (frame) {
        final raw = json.decode(frame.body!) as List;
        debugPrint("requestMessages raw: $raw");
        final messages = raw.map((e) => Message.fromJson(e)).toList();
        onMessagesReceived?.call(messages);
      });

      final user = userModelAppInterface.user;
      final userId = user?.id;

      if (user == null || userId == null) {
        throw Exception('Пользователь не авторизован или данные неполные');
      }
      final messagesToSend = {"chatId": chatId, "userId": userId};

      _send('/app/chat.getMessages', messagesToSend);
    });
  }

  void sendMessage(Message message) {
    _enqueueOrRun(() {
      _send('/app/chat.sendMessage', message.toJson());
    });
  }

  void actionSub({required String chatId}) {
    _subscribe('/topic/chat.activity.$chatId', (frame) {
      final data = json.decode(frame.body!);
      final activity = UserActivity.fromJson(data);
      onUserActivity?.call(activity);
    });
  }

  void sendActivity(UserActivity activity) {
    _enqueueOrRun(() {
      _send("/app/chat.activity", activity.toJson());
    });
  }

  void getActiveTemporary(String userId) {
    _enqueueOrRun(() {
      _send('/app/chat.getActiveTemporary', userId);
    });
  }

  void getPermanent(String userId) {
    _enqueueOrRun(() {
      _send('/app/chat.getPermanent', userId);
    });
  }

  void _send(String destination, dynamic payload) {
    final body = jsonEncode(payload);
    debugPrint('[SocketService] Sending to $destination: $body');
    _stompClient.send(destination: destination, body: body);
  }

  void _subscribe(
    String destination,
    void Function(StompFrame frame) callback,
  ) {
    debugPrint('[SocketService] Subscribing to $destination');
    _stompClient.subscribe(destination: destination, callback: callback);
  }

  void _enqueueOrRun(void Function() action) {
    if (_isConnected) {
      action();
    } else {
      debugPrint('[SocketService] Action queued');
      _pendingActions.add(action);
    }
  }

  void disconnect() {
    _stompClient.deactivate();
    _isConnected = false;
    debugPrint('[SocketService] Disconnected manually.');
  }
}
