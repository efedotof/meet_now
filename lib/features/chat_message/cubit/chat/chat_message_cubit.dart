import 'dart:async';
import 'package:bloc/bloc.dart';
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

  ChatMessageCubit({required MessageInterface messageInterface})
    : _messageInterface = messageInterface,
      super(const ChatMessageState.initial());

  void connect(String chatId) {
    if (_currentChatId == chatId || isClosed) return;

    _currentChatId = chatId;
    _disposeSubscriptions();
    emit(const ChatMessageState.loading());

    _messagesSubscription = _messageInterface.messagesStream.listen(
      (messages) {
        if (isClosed) return;
        emit(ChatMessageState.loaded(messages: messages));
      },
      onError: (e) {
        if (isClosed) return;
        emit(ChatMessageState.error(e.toString()));
      },
    );

    _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
      (newMessage) {
        if (isClosed) return;
        state.maybeMap(
          loaded: (state) {
            final updatedMessages = List<Message>.from(state.messages)
              ..add(newMessage);
            emit(state.copyWith(messages: updatedMessages));
          },
          orElse: () {
            emit(ChatMessageState.loaded(messages: [newMessage]));
          },
        );
      },
      onError: (e) {
        if (isClosed) return;
        emit(ChatMessageState.error(e.toString()));
      },
    );

    _messageInterface.requestMessages(chatId);
  }

  void sendMessage(Message message) {
    if (isClosed) return;

    state.maybeMap(
      loaded: (state) {
        final optimisticMessage = message.copyWith(createdAt: DateTime.now());

        final updatedMessages = List<Message>.from(state.messages)
          ..add(optimisticMessage);

        emit(state.copyWith(messages: updatedMessages));
        _messageInterface.sendMessage(message);
      },
      orElse: () => _messageInterface.sendMessage(message),
    );
  }

  void _disposeSubscriptions() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;

    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
  }

  void disconnect() {
    _disposeSubscriptions();
    _currentChatId = null;
  }

  @override
  Future<void> close() {
    _disposeSubscriptions();
    return super.close();
  }
}
