import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/widget.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

@RoutePage()
class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({
    required this.temporaryChatModel,
    this.chatModel,
    super.key,
  });

  final TemporaryChat? temporaryChatModel;
  final Chat? chatModel;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final bool isTemporary;
  late final String _chatId;
  late final String _senderId;
  late final String _recipientId;
  late StreamSubscription<ChatMessageState> _subscription;
  late final ChatMessageCubit _cubit;

  void _handleCommandResult(String result) {
    final message = Message(
      senderId: _senderId,
      recipientId: _recipientId,
      text: result,
      createdAt: DateTime.now(),
      chatId: isTemporary ? null : _chatId,
      tempChatId: isTemporary ? _chatId : null,
    );
    _cubit.sendMessage(message);
  }

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChatMessageCubit>();
    isTemporary = widget.chatModel == null;
    final currentUser = context.read<UserModelAppInterface>().user;
    if (currentUser == null) {
      throw Exception('Current user not available');
    }
    _chatId =
        isTemporary
            ? widget.temporaryChatModel!.tempChatId
            : widget.chatModel!.chatId;

    _senderId = currentUser.id;

    _recipientId =
        isTemporary
            ? _getTemporaryChatRecipient(currentUserId: currentUser.id)
            : _getChatRecipient(currentUserId: currentUser.id);
    _cubit.connect(_chatId);

    _subscription = _cubit.stream.listen((state) {
      state.maybeMap(loaded: (_) => _scrollToBottom(), orElse: () {});
    });
  }

  String _getChatRecipient({required String currentUserId}) {
    if (widget.chatModel == null) return '';
    final chat = widget.chatModel!;
    if (chat.user1.id == currentUserId) {
      return chat.user2.id;
    } else {
      return chat.user1.id;
    }
  }

  String _getTemporaryChatRecipient({required String currentUserId}) {
    if (widget.temporaryChatModel == null) return "";
    final tempChat = widget.temporaryChatModel;
    if (tempChat!.senderId == currentUserId) {
      return tempChat.recipientId;
    } else {
      return tempChat.senderId;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _cubit.disconnect();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendNormalMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      senderId: _senderId,
      recipientId: _recipientId,
      text: text,
      createdAt: DateTime.now(),
      chatId: isTemporary ? null : _chatId,
      tempChatId: isTemporary ? _chatId : null,
    );
    _cubit.sendMessage(message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(chatModel: widget.chatModel),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
              builder: (context, state) {
                return state.when(
                  initial:
                      () => const Center(child: CircularProgressIndicator()),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (message) => Center(child: Text('Ошибка: $message')),
                  loaded: (messages, isLoadingMore) {
                    return Column(
                      children: [
                        if (isLoadingMore)
                          const LinearProgressIndicator(minHeight: 2),
                        Expanded(
                          child: MessagesList(
                            messages: messages,
                            scrollController: _scrollController,
                            currentUserId: _senderId,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          InputArea(
            controller: _messageController,
            onSend: _sendNormalMessage,
            onCommandResult: _handleCommandResult,
          ),
        ],
      ),
    );
  }
}
