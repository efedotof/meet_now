import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/chat/chat_interface.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required ChatInterface chatInterface})
    : _chatInterface = chatInterface,
      super(ChatState.initial());
  final ChatInterface _chatInterface;

  Future<void> getChatsUser({required BuildContext context}) async {
    try {
      final temporaryChat = await _chatInterface.getActiveTemporary();
      List<Chat> permomentChat = await _chatInterface.getChatPermanent();
      debugPrint(temporaryChat.toString());

      emit(
        ChatState.getChats(
          temporaryChat: temporaryChat,
          permomentChat: permomentChat,
        ),
      );
    } catch (e) {
      debugPrint("getChatUser error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Произошла ошибка : $e")));
      }
    }
  }
}
