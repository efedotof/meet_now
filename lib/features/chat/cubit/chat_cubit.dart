import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/chat/chat_interface.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatInterface _chatInterface;

  ChatCubit({required ChatInterface chatInterface})
    : _chatInterface = chatInterface,
      super(const ChatState.initial());

  Future<void> getChatsUser({required BuildContext context}) async {
    try {
      final temporaryChats = await _chatInterface.getActiveTemporary();
      final permanentChats = await _chatInterface.getChatPermanent();
      emit(
        ChatState.getChats(
          temporaryChat: temporaryChats,
          permomentChat: permanentChats,
        ),
      );
    } catch (e) {
      debugPrint("getChatsUser error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка при получении чатов: $e")),
        );
      }
    }
  }
}
