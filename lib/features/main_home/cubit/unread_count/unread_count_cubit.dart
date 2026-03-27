import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';

part 'unread_count_state.dart';
part 'unread_count_cubit.freezed.dart';

class UnreadCountCubit extends Cubit<UnreadCountState> {
  UnreadCountCubit({required SocketServiceInterface socketService})
    : super(const UnreadCountState.initial()) {
    _subscribe(socketService);
  }

  StreamSubscription<List<PermanentChatResponseDto>>? _permSub;
  StreamSubscription<List<TemporaryChat>>? _tempSub;

  List<PermanentChatResponseDto> _permanentChats = [];

  void _subscribe(SocketServiceInterface socketService) {
    _permSub = socketService.permanentChatsStream.listen(
      (chats) {
        _permanentChats = chats;
        _updateTotal();
      },
      onError: (e) {
        emit(const UnreadCountState.loaded(0));
      },
    );

    _tempSub = socketService.temporaryChatsStream.listen(
      (chats) {
        // Временные чаты в данный момент не имеют поля unreadCount,
        // но подписка оставлена для возможного будущего использования.
        _updateTotal();
      },
      onError: (e) {
        emit(const UnreadCountState.loaded(0));
      },
    );
  }

  void _updateTotal() {
    final total = _permanentChats.fold<int>(
      0,
      (sum, chat) => sum + (chat.unreadCount ?? 0),
    );
    emit(UnreadCountState.loaded(total));
  }

  @override
  Future<void> close() {
    _permSub?.cancel();
    _tempSub?.cancel();
    return super.close();
  }
}
