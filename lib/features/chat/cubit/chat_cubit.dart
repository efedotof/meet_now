import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/chat/chat_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatInterface _chatInterface;
  final UserModelAppInterface _userModelAppInterface;
  StreamSubscription<List<Chat>>? _permanentChatsSub;
  StreamSubscription<List<TemporaryChat>>? _temporaryChatsSub;

  List<Chat> _permanentChats = [];
  List<TemporaryChat> _temporaryChats = [];

  ChatCubit({
    required ChatInterface chatInterface,
    required UserModelAppInterface userModelAppInterface,
  }) : _userModelAppInterface = userModelAppInterface,
       _chatInterface = chatInterface,
       super(const ChatState.initial());

  void init({required BuildContext context}) {
    final user = _userModelAppInterface.user;
    if (user == null || user.id.isEmpty) {
      throw Exception('Пользователь не авторизован или ID пустой');
    }

    _chatInterface.init(user.id);
    getChatsUser(context: context);
  }

  Future<void> getChatsUser({required BuildContext context}) async {
    try {
      _permanentChatsSub = _chatInterface.chatStream.listen((chats) {
        debugPrint(
          "[ChatCubit] permanentChats stream: ${chats.map((e) => e.toJson())}",
        );
        _permanentChats = chats;
        _emitCombined();
      });

      _temporaryChatsSub = _chatInterface.temporaryChatStream.listen((chats) {
        debugPrint(
          "[ChatCubit] temporaryChats stream: ${chats.map((e) => e.toJson())}",
        );
        _temporaryChats = chats;
        _emitCombined();
      });

      // Запрашиваем чаты у сокет-интерфейса
      debugPrint("[getChatsUser] ➤ requesting chats...");
      _chatInterface.getChatPermanent();
      _chatInterface.getActiveTemporary();
    } catch (e) {
      debugPrint("[getChatsUser] ❌ error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка при получении чатов: $e")),
        );
      }
    }
  }

  void _emitCombined() {
    emit(
      ChatState.getChats(
        temporaryChat: _temporaryChats,
        permomentChat: _permanentChats,
      ),
    );
  }

  @override
  Future<void> close() {
    _permanentChatsSub?.cancel();
    _temporaryChatsSub?.cancel();
    return super.close();
  }
}
