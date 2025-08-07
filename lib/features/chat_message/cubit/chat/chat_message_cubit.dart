import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';

part 'chat_message_state.dart';
part 'chat_message_cubit.freezed.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  StreamSubscription<List<Message>>? _messagesSubscription;
  StreamSubscription<Message>? _singleMessageSubscription;
  final MessageInterface _messageInterface;
  String? _currentChatId;
  late String _senderId;
  late String _recipientId;
  late bool _isTemporary;

  ChatMessageCubit({required MessageInterface messageInterface})
    : _messageInterface = messageInterface,
      super(const ChatMessageState.initial());

  void initialize({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
  }) {
    if (_currentChatId == chatId) return;

    _isTemporary = isTemporary;
    _currentChatId = chatId;
    _senderId = senderId;
    _recipientId = recipientId;

    _disposeSubscriptions();
    emit(const ChatMessageState.loading());

    _messagesSubscription = _messageInterface.messagesStream.listen(
      (messages) => emit(ChatMessageState.loaded(messages: messages)),
      onError: (e) => emit(ChatMessageState.error(e.toString())),
    );

    _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
      (newMessage) => state.maybeMap(
        loaded:
            (state) =>
                emit(state.copyWith(messages: [...state.messages, newMessage])),
        orElse: () => emit(ChatMessageState.loaded(messages: [newMessage])),
      ),
    );

    _messageInterface.requestMessages(chatId);
  }

  void sendTextMessage(String text) {
    if (text.isEmpty) return;

    final message = Message(
      senderId: _senderId,
      recipientId: _recipientId,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary ? null : _currentChatId,
      tempChatId: _isTemporary ? _currentChatId : null,
    );

    state.maybeMap(
      loaded: (state) {
        final optimisticMessage = message.copyWith(createdAt: DateTime.now());
        emit(state.copyWith(messages: [...state.messages, optimisticMessage]));
        _messageInterface.sendMessage(message);
      },
      orElse: () => _messageInterface.sendMessage(message),
    );
  }

  void reconnect({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
  }) {
    if (_currentChatId != null) {
      _disposeSubscriptions();
      emit(const ChatMessageState.loading());
      initialize(
        isTemporary: isTemporary,
        chatId: chatId,
        senderId: senderId,
        recipientId: recipientId,
        context: context,
      );
    }
  }

  void _disposeSubscriptions() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
  }

  @override
  Future<void> close() {
    _disposeSubscriptions();
    return super.close();
  }
}
