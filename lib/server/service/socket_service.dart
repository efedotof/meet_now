import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

typedef MessageCallback = void Function(List<Message> messages);
typedef SingleMessageCallback = void Function(Message message);
typedef ChatListCallback = void Function(List<Chat> chats);
typedef TemporaryChatListCallback = void Function(List<TemporaryChat> chats);

class SocketService {
  late final StompClient _stompClient;
  final String userId;
  final UserModelAppInterface userModelAppInterface;
  final MessageCallback onMessagesReceived;
  final SingleMessageCallback onSingleMessageReceived;
  final ChatListCallback? onPermanentChatsReceived;
  final TemporaryChatListCallback? onTemporaryChatsReceived;

  bool _isConnected = false;
  final List<void Function()> _pendingActions = [];

  SocketService({
    required this.userId,
    required this.onMessagesReceived,
    required this.onSingleMessageReceived,
    required this.userModelAppInterface,
    required this.onPermanentChatsReceived,
    required this.onTemporaryChatsReceived,
  });

  void connect() {
    debugPrint('[SocketService] Connecting...');
    final token = userModelAppInterface.user?.token;
    if (token == null || token.isEmpty) {
      throw Exception('Отсутствует токен авторизации');
    }
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: socketAddress,
        onConnect: onConnect,
        onWebSocketError:
            (error) => debugPrint('[SocketService] WebSocket Error: $error'),
        onStompError:
            (frame) => debugPrint('[SocketService] STOMP Error: ${frame.body}'),
        onDisconnect: (_) {
          debugPrint('[SocketService] Disconnected');
          _isConnected = false;
        },
      ),
    );

    _stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    debugPrint('[SocketService] Connected');
    _isConnected = true;

    _subscribe('/user/queue/messages', (frame) {
      final data = json.decode(frame.body!);
      debugPrint('[SocketService] 🔍 Single message (raw): $data');
      final message = Message.fromJson(data);
      debugPrint('[SocketService] ✅ Parsed single message: $message');
      onSingleMessageReceived(message);
    });

    _subscribe('/user/queue/chat.permanent', (frame) {
      final raw = json.decode(frame.body!) as List;
      debugPrint('[SocketService] 🔍 Raw permanent chats: $raw');
      final chats = raw.map((e) => Chat.fromJson(e)).toList();
      debugPrint("[SocketService] ✅ Permanent chats received: ${chats.length}");
      for (final chat in chats) {
        debugPrint('[SocketService] • Chat: $chat');
      }
      onPermanentChatsReceived?.call(chats);
    });

    _subscribe('/user/queue/chat.temporary.active', (frame) {
      final raw = json.decode(frame.body!) as List;
      debugPrint('[SocketService] 🔍 Raw temporary chats: $raw');
      final chats = raw.map((e) => TemporaryChat.fromJson(e)).toList();
      debugPrint("[SocketService] ✅ Temporary chats received: ${chats.length}");
      for (final tempChat in chats) {
        debugPrint('[SocketService] • TemporaryChat: $tempChat');
      }
      onTemporaryChatsReceived?.call(chats);
    });

    for (final action in _pendingActions) {
      action();
    }
    _pendingActions.clear();
  }

  void requestMessages(String chatId) {
    _enqueueOrRun(() {
      debugPrint('[SocketService] Requesting messages for chat $chatId');

      _subscribe('/user/queue/chat.$chatId.messages', (frame) {
        final raw = json.decode(frame.body!) as List;
        debugPrint('[SocketService] 🔍 Raw messages for chat $chatId: $raw');
        final messages = raw.map((e) => Message.fromJson(e)).toList();
        for (final message in messages) {
          debugPrint('[SocketService] • Message: $message');
        }
        onMessagesReceived(messages);
      });

      _send('/app/chat.getMessages', chatId);
    });
  }

  void sendMessage(Message message) {
    _enqueueOrRun(() {
      debugPrint('[SocketService] Sending message');
      _send('/app/chat.sendMessage', message.toJson());
    });
  }

  void getActiveTemporary(String userId) {
    _enqueueOrRun(() {
      debugPrint(
        '[SocketService] Sending getActiveTemporary request for userId=$userId',
      );
      _send('/app/chat.getActiveTemporary', userId);
    });
  }

  void getPermanent(String userId) {
    _enqueueOrRun(() {
      debugPrint(
        '[SocketService] Sending getPermanent request for userId=$userId',
      );
      _send('/app/chat.getPermanent', userId);
    });
  }

  void disconnect() {
    _stompClient.deactivate();
  }

  void _enqueueOrRun(void Function() action) {
    if (_isConnected) {
      action();
    } else {
      debugPrint('[SocketService] Action queued');
      _pendingActions.add(action);
    }
  }

  void _send(String destination, dynamic payload) {
    final String body = json.encode(payload);
    debugPrint('[SocketService] Sending to $destination with payload: $body');
    _stompClient.send(destination: destination, body: body);
  }

  void _subscribe(
    String destination,
    void Function(StompFrame frame) callback,
  ) {
    debugPrint('[SocketService] Subscribing to $destination');
    _stompClient.subscribe(destination: destination, callback: callback);
  }
}
