import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat_timer/chat_timer_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/app_bar_widget.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';

import 'error_message.dart';
import 'input_area.dart';
import 'loading_messages.dart';
import 'messages_list.dart';

class BuildScaffold extends StatelessWidget {
  const BuildScaffold({super.key, required this.theme, required String currentUserId, this.chatModel, required this.onBackPressed, required this.isTemporary, required String chatId, required String senderID, required String recipientId, required TextEditingController messageController, required void Function() sendMessage, required ScrollController scrollController}) : _currentUserId = currentUserId, _recipientId = recipientId, _senderID = senderID, _chatId = chatId, _sendMessage = sendMessage, _scrollController = scrollController, _messageController = messageController;

  final ThemeData theme;
  final String _currentUserId;
  final Chat? chatModel;
  final VoidCallback onBackPressed;
  final bool isTemporary;
  final String _chatId;
  final String _senderID;
  final String _recipientId;
  final TextEditingController _messageController;
  final VoidCallback _sendMessage;
  final ScrollController _scrollController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBarWidget(
        chatModel: chatModel,
        userId: _currentUserId,
        onBackPressed: onBackPressed,
        isTemporary: isTemporary,
        remainingSeconds: isTemporary
            ? context.select(
                (ChatTimerCubit cubit) => cubit.state.maybeMap(
                  running: (state) => state.remainingSeconds,
                  orElse: () => null,
                ),
              )
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
                builder: (context, state) {
                  final cubit = context.read<ChatMessageCubit>();

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: state.when(
                      initial: () => const LoadingMessages(),
                      loading: () => const LoadingMessages(),
                      error: (message) => ErrorMessage(
                        message: message,
                        onRetry: () => cubit.reconnect(
                          context: context,
                          isTemporary: isTemporary,
                          chatId: _chatId,
                          senderId: _senderID,
                          recipientId: _recipientId,
                        ),
                      ),
                      loaded: (messages, isLoadingMore) => Column(
                        children: [
                          if (isLoadingMore)
                            const LinearProgressIndicator(
                              minHeight: 2,
                              color: Colors.blueAccent,
                            ),
                          Expanded(
                            child: MessagesList(
                              messages: messages,
                              scrollController: _scrollController,
                              currentUserId: _currentUserId,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            InputArea(
              controller: _messageController,
              onSend: _sendMessage,
              onCommandResult: (result) {
                context.read<ChatMessageCubit>().sendTextMessage(result);
              },
              chatId: _chatId,
            ),
          ],
        ),
      ),
    );
  }
}