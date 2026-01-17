import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app_server/model/chats/message/message.dart';
import 'message/gift_message.dart';
import 'message/message_bubble.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    super.key,
    required this.scrollController,
    required this.currentUserId,
  });

  final ScrollController scrollController;
  final String currentUserId;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final double _scrollThreshold = 200.0;
  final Map<String, GlobalKey> _messageKeys = {};
  Timer? _visibilityCheckTimer;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _startVisibilityCheckTimer();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _visibilityCheckTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore || !_hasMore) return;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold &&
        widget.scrollController.position.atEdge) {
      _loadMoreMessages();
    }
  }

  void _loadMoreMessages() {
    final cubit = context.read<ChatMessageCubit>();
    final state = cubit.state;

    state.maybeMap(
      loaded: (state) {
        if (!state.isLoadingMore && state.hasMore) {
          setState(() {
            _isLoadingMore = true;
          });

          cubit.loadMoreMessages();

          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _isLoadingMore = false;
              });
            }
          });
        }
      },
      orElse: () => null,
    );
  }

  void _startVisibilityCheckTimer() {
    _visibilityCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkVisibleMessages();
    });
  }

  void _checkVisibleMessages() {
    if (!widget.scrollController.hasClients) return;

    final visibleMessages = <Message>[];
    final cubit = context.read<ChatMessageCubit>();
    final state = cubit.state;

    state.maybeMap(
      loaded: (state) {
        final messages = state.messages;

        for (final message in messages) {
          if (message.senderId == widget.currentUserId || message.read) {
            continue;
          }

          final key = _messageKeys[message.id];
          if (key != null && key.currentContext != null) {
            final renderBox =
                key.currentContext!.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              final position = renderBox.localToGlobal(Offset.zero);
              final size = renderBox.size;

              if (_isWidgetVisible(position, size)) {
                visibleMessages.add(message);
              }
            }
          }
        }

        if (visibleMessages.isNotEmpty) {
          cubit.markMessagesAsRead(visibleMessages);
        }
      },
      orElse: () => null,
    );
  }

  bool _isWidgetVisible(Offset position, Size size) {
    final screenHeight = MediaQuery.of(context).size.height;

    return position.dy + size.height > 0 && position.dy < screenHeight;
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatMessageCubit, ChatMessageState>(
      listener: (context, state) {
        state.maybeMap(
          loaded: (state) {
            _hasMore = state.hasMore;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_shouldAutoScroll()) {
                _scrollToBottom();
              }
            });
          },
          orElse: () => null,
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          loaded: (loadedState) {
            final messages = loadedState.messages;

            _messageKeys.removeWhere(
              (key, _) => !messages.any((message) => message.id == key),
            );

            for (final message in messages) {
              if (message.id != null && !_messageKeys.containsKey(message.id)) {
                _messageKeys[message.id!] = GlobalKey();
              }
            }

            return CustomScrollView(
              controller: widget.scrollController,
              reverse: false,
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 100)),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == widget.currentUserId;
                    final showTime = _shouldShowTime(index, messages);
                    if (message.isGift) {
                      debugPrint("Получен подарок: $message");
                    }
                    return Column(
                      key:
                          message.id != null ? _messageKeys[message.id!] : null,
                      crossAxisAlignment:
                          message.isGift
                              ? CrossAxisAlignment.center
                              : (isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start),

                      children: [
                        if (message.isGift)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: GiftMessage(
                              message: message,
                              isMe: isMe,
                              theme: Theme.of(context),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMe ? 60 : 16,
                              right: isMe ? 16 : 60,
                              top: 4,
                              bottom: showTime ? 4 : 8,
                            ),
                            child: MessageBubble(
                              message: message,
                              isMe: isMe,
                              theme: Theme.of(context),
                            ),
                          ),
                        if (showTime)
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMe ? 0 : 16,
                              right: isMe ? 16 : 0,
                              bottom: 16,
                            ),
                            child: Text(
                              DateFormat.Hm().format(message.createdAt!),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    );
                  }, childCount: messages.length),
                ),

                if (loadedState.isLoadingMore)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
          loading:
              (loadingState) =>
                  const Center(child: CircularProgressIndicator()),
          error: (errorState) => Center(child: Text(errorState.message)),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  bool _shouldShowTime(int index, List<Message> messages) {
    if (index == messages.length - 1) return true;

    final current = messages[index];
    final next = messages[index + 1];

    if (current.senderId != next.senderId) return true;

    final timeDifference = next.createdAt!.difference(current.createdAt!);
    return timeDifference.inMinutes > 5;
  }

  bool _shouldAutoScroll() {
    if (!widget.scrollController.hasClients) return false;

    final currentScroll = widget.scrollController.position.pixels;

    return currentScroll <= 200;
  }
}
