import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/repository/message/message_interface.dart';

part 'chat_message_state.dart';
part 'chat_message_cubit.freezed.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  ChatMessageCubit({required this.messageInterface})
    : super(const ChatMessageState.initial());

  final MessageInterface messageInterface;
  final List<Message> _messages = [];

  void connect(String userId, String chatId) {
    // messageInterface.init(userId);

    messageInterface.messagesStream.listen((messages) {
      _messages
        ..clear()
        ..addAll(messages);
      emit(ChatMessageState.loaded(messages: List.from(_messages)));
    });

    messageInterface.incomingMessageStream.listen((message) {
      _messages.add(message);
      debugPrint("getMessage");
      emit(ChatMessageState.loaded(messages: List.from(_messages)));
    });
    debugPrint("Полученные сообщения: ${_messages.toString()}");
    messageInterface.requestMessages(chatId);
  }

  void getMessages(String chatId) {
    messageInterface.requestMessages(chatId);
  }

  void sendMessage(Message message) {
    _messages.add(message);
    messageInterface.sendMessage(message);
    emit(ChatMessageState.loaded(messages: List.from(_messages)));
  }

  void disconnect() {
    messageInterface.dispose();
  }
}
