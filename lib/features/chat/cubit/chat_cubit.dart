import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  late final StreamSubscription _permanentSub;
  late final StreamSubscription _temporarySub;

  final SocketServiceInterface _socketServiceInterface;

  ChatCubit({
    required SocketServiceInterface socketServiceInterface,
    required UserModelAppInterface userModelAppInterface,
  }) : _socketServiceInterface = socketServiceInterface,
       super(
         const ChatState(permanentChat: [], temporaryChat: [], isLoading: true),
       ) {
    _init();
  }

  void _init() {
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

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, error: null));
    _socketServiceInterface.getPermanent();
    _socketServiceInterface.getActiveTemporary();
  }

  @override
  Future<void> close() {
    _permanentSub.cancel();
    _temporarySub.cancel();
    return super.close();
  }
}
