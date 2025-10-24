import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/app_bar_widget.dart';
import 'package:meet_now_app_server/model/permanent_chat_response_dto/permanent_chat_response_dto.dart';

import 'error_message.dart';
import 'input/input_area.dart';
import 'loading_messages.dart';
import 'messages_list.dart';

class BuildScaffold extends StatelessWidget {
  const BuildScaffold({
    super.key,
    required this.theme,
    required this.currentUserId,
    this.chatModel,
    required this.onBackPressed,
    required this.isTemporary,
    required this.chatId,
    required this.senderID,
    required this.recipientId,
    required this.messageController,
    required this.sendMessage,
    required this.scrollController,
    required this.onAddAttach,
  });

  final ThemeData theme;
  final String currentUserId;
  final PermanentChatResponseDto? chatModel;
  final VoidCallback onBackPressed;
  final bool isTemporary;
  final String chatId;
  final String senderID;
  final String recipientId;
  final TextEditingController messageController;
  final VoidCallback sendMessage;
  final ScrollController scrollController;
  final VoidCallback onAddAttach;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBarWidget(
        chatModel: chatModel,
        userId: currentUserId,
        onBackPressed: onBackPressed,
        isTemporary: isTemporary,
        timerText: isTemporary
            ? context.select(
                (SyncTimerCubit cubit) => cubit.state.formattedTime,
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
            if (isTemporary)
              BlocBuilder<SyncTimerCubit, SyncTimerState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    running: (remainingTime, formattedTime) => Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<SyncTimerCubit>().proposeAddTime(1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('1 мин'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<SyncTimerCubit>().proposeAddTime(3);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('3 мин'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<SyncTimerCubit>().proposeAddTime(5);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('5 мин'),
                          ),
                        ],
                      ),
                    ),
                    finished: () => const SizedBox.shrink(),
                    addTimeProposed: (
                      remainingTime,
                      formattedTime,
                      additionalMinutes,
                      fromUserId,
                    ) =>
                        const SizedBox.shrink(),
                    waitingForResponse: (
                      remainingTime,
                      formattedTime,
                      additionalMinutes,
                    ) =>
                        const SizedBox.shrink(),
                    timeAdded: (additionalMinutes) => const SizedBox.shrink(),
                    timeRejected: () => const SizedBox.shrink(),
                  );
                },
              ),
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
                          chatId: chatId,
                          senderId: senderID,
                          recipientId: recipientId,
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
                              scrollController: scrollController,
                              currentUserId: currentUserId,
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
              controller: messageController,
              onSend: sendMessage,
              onCommandResult: (result) {
                context.read<ChatMessageCubit>().sendTextMessage(result);
              },
              chatId: chatId,
              onAddAttach: onAddAttach,
            ),
          ],
        ),
      ),
    );
  }
}