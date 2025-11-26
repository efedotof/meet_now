import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
import 'package:meet_now_app/features/chat_message/widget/app_bar_widget.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';

import 'chat_messages_skeleton.dart';
import 'error_message.dart';
import 'input/input_area.dart';
import 'messages_list.dart';

class BuildScaffold extends StatefulWidget {
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
    required this.onContinueChat,
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
  final VoidCallback? onAddAttach;
  final VoidCallback? onContinueChat;

  @override
  State<BuildScaffold> createState() => _BuildScaffoldState();
}

class _BuildScaffoldState extends State<BuildScaffold> {
  bool _showScrollToBottomButton = false;
  bool _isUserScrolling = false;
  late ScrollController _scrollController;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    final isAtBottom = currentScroll >= maxScroll - 20;

    if (_scrollController.position.isScrollingNotifier.value) {
      _isUserScrolling = true;

      _scrollTimer?.cancel();
      _scrollTimer = Timer(const Duration(milliseconds: 500), () {
        _isUserScrolling = false;
      });
    }

    if (!isAtBottom != _showScrollToBottomButton) {
      setState(() {
        _showScrollToBottomButton = !isAtBottom;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && !_isUserScrolling) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToBottomImmediately() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() {
        _showScrollToBottomButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.colorScheme.surface,
      appBar: AppBarWidget(
        chatModel: widget.chatModel,
        userId: widget.currentUserId,
        onBackPressed: widget.onBackPressed,
        isTemporary: widget.isTemporary,
        timerText:
            widget.isTemporary
                ? context.select(
                  (SyncTimerCubit cubit) => cubit.state.formattedTime,
                )
                : null,
        onContinueChat: widget.onContinueChat,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.theme.colorScheme.surface,
              widget.theme.colorScheme.surface,
              widget.theme.colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                if (widget.isTemporary)
                  BlocBuilder<SyncTimerCubit, SyncTimerState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox.shrink(),
                        running:
                            (remainingTime, formattedTime) => Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.grey[100],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<SyncTimerCubit>()
                                          .proposeAddTime(1);
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
                                      context
                                          .read<SyncTimerCubit>()
                                          .proposeAddTime(3);
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
                                      context
                                          .read<SyncTimerCubit>()
                                          .proposeAddTime(5);
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
                                  if (widget.onContinueChat != null)
                                    ElevatedButton(
                                      onPressed: widget.onContinueChat,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: const Text('Продолжить чат'),
                                    ),
                                ],
                              ),
                            ),
                        finished: () => const SizedBox.shrink(),
                        addTimeProposed:
                            (
                              remainingTime,
                              formattedTime,
                              additionalMinutes,
                              fromUserId,
                            ) => const SizedBox.shrink(),
                        waitingForResponse:
                            (remainingTime, formattedTime, additionalMinutes) =>
                                const SizedBox.shrink(),
                        timeAdded:
                            (additionalMinutes) => const SizedBox.shrink(),
                        timeRejected: () => const SizedBox.shrink(),
                        timeOptions:
                            (remainingTime, formattedTime) =>
                                const SizedBox.shrink(),
                        error: (String message) => Text(message),
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
                          initial: () => const ChatMessagesSkeleton(),
                          loading: () => const ChatMessagesSkeleton(),
                          error:
                              (message) => ErrorMessage(
                                message: message,
                                onRetry:
                                    () => cubit.reconnect(
                                      context: context,
                                      isTemporary: widget.isTemporary,
                                      chatId: widget.chatId,
                                      senderId: widget.senderID,
                                      recipientId: widget.recipientId,
                                    ),
                              ),
                          loaded: (
                            messages,
                            isLoadingMore,
                            isTemporary,
                            showContinueRequest,
                            isWaitingForResponse,
                            agreeChatResponse,
                          ) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (messages.isNotEmpty &&
                                  !isLoadingMore &&
                                  !_isUserScrolling) {
                                _scrollToBottom();
                              }
                            });

                            return Column(
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
                                    currentUserId: widget.currentUserId,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                InputArea(
                  controller: widget.messageController,
                  onSend: () {
                    widget.sendMessage();
                    _scrollToBottomImmediately();
                  },
                  onCommandResult: (result) {
                    context.read<ChatMessageCubit>().sendTextMessage(result);
                    _scrollToBottomImmediately();
                  },
                  chatId: widget.chatId,
                  onAddAttach: widget.onAddAttach,
                  onStickerSelected: (sticker) {
                    context.read<ChatMessageCubit>().sendStickerMessage(
                      sticker,
                    );
                    _scrollToBottomImmediately();
                  },
                  isTemporary: widget.isTemporary,
                ),
              ],
            ),

            if (_showScrollToBottomButton)
              Positioned(
                bottom: 80,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: _scrollToBottomImmediately,
                  backgroundColor: widget.theme.colorScheme.primary,
                  foregroundColor: widget.theme.colorScheme.onPrimary,
                  child: const Icon(Icons.arrow_downward_rounded),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
