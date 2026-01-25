import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/chats/delete_chat_request/delete_chat_request.dart';
import 'package:meet_now_app_server/model/chats/delete_temporary_chat_request/delete_temporary_chat_request.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';
import 'package:meet_now_app_server/repository/chat/chat_interface.dart';
import 'package:meet_now_app_server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  late final StreamSubscription _permanentSub;
  late final StreamSubscription _temporarySub;
  final UserModelAppInterface _userModelAppInterface;
  final SocketServiceInterface _socketServiceInterface;
  final ChatInterface _chatInterface;

  ChatCubit({
    required ChatInterface chatInterface,
    required SocketServiceInterface socketServiceInterface,
    required UserModelAppInterface userModelAppInterface,
  }) : _chatInterface = chatInterface,
       _userModelAppInterface = userModelAppInterface,
       _socketServiceInterface = socketServiceInterface,
       super(
         const ChatState(
           permanentChat: [],
           temporaryChat: [],
           isLoading: true,
           selectedChatType: ChatType.all,
         ),
       ) {
    _init();
  }

  void _init() {
    final user = _userModelAppInterface.user;
    emit(state.copyWith(currentUserId: user?.id));

    _socketServiceInterface.getPermanent();
    _socketServiceInterface.getActiveTemporary();

    _permanentSub = _socketServiceInterface.permanentChatsStream.listen(
      (chats) {
        emit(
          state.copyWith(permanentChat: chats, isLoading: false, error: null),
        );
      },
      onError:
          (e) => emit(state.copyWith(error: e.toString(), isLoading: false)),
    );

    _temporarySub = _socketServiceInterface.temporaryChatsStream.listen(
      (chats) {
        emit(
          state.copyWith(temporaryChat: chats, isLoading: false, error: null),
        );
      },
      onError:
          (e) => emit(state.copyWith(error: e.toString(), isLoading: false)),
    );
  }

  void changeChatType(ChatType chatType) {
    emit(state.copyWith(selectedChatType: chatType));
  }

  Future<void> deletePermanentChat(
    String chatId,
    String userId,
    bool deleteForBoth,
  ) async {
    try {
      await _chatInterface.deletePermanentChat(
        request: DeleteChatRequest(
          chatId: chatId,
          userId: userId,
          deleteForBoth: deleteForBoth,
        ),
      );

      final updatedChats =
          state.permanentChat.where((chat) => chat.chatId != chatId).toList();
      emit(state.copyWith(permanentChat: updatedChats));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка при удалении чата: ${e.toString()}'));
    }
  }

  Future<void> deleteTemporaryChat(
    String tempChatId,
    bool deleteForBoth,
  ) async {
    try {
      await _chatInterface.deleteTemporaryChat(
        request: DeleteTemporaryChatRequest(
          tempChatId: tempChatId,
          userId: state.currentUserId!,
          deleteForBoth: deleteForBoth,
        ),
      );

      final updatedChats =
          state.temporaryChat
              .where((chat) => chat.tempChatId != tempChatId)
              .toList();
      emit(state.copyWith(temporaryChat: updatedChats));
    } catch (e) {
      emit(state.copyWith(error: 'Ошибка при удалении чата: ${e.toString()}'));
    }
  }

  void openChat({required String chatId}) {
    _socketServiceInterface.openChat(chatId: chatId);
  }

  void openTempChat({required String tempChatId}) {
    _socketServiceInterface.openTempChat(tempChatId: tempChatId);
  }

  void closeChat({required String chatId}) {
    _socketServiceInterface.closeChat(chatId: chatId);
  }

  void closeTempChat({required String tempChatId}) {
    _socketServiceInterface.closeTempChat(tempChatId: tempChatId);
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, error: null));
    _socketServiceInterface.getPermanent();
    _socketServiceInterface.getActiveTemporary();
  }

  Future<PermanentChatResponseDto?> createPermomentChat({
    required String user2id,
  }) async {
    try {
      final chat = await _chatInterface.createOrGetPermanentChat(
        user2id: user2id,
      );

      if (chat.chatId != "") {
        return chat;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }

  @override
  Future<void> close() {
    _permanentSub.cancel();
    _temporarySub.cancel();
    return super.close();
  }
}
