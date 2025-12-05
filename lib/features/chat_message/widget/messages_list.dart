import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_now_app_server/model/chats/message/message.dart';
import 'message/message_bubble.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.currentUserId,
  });

  final List<Message> messages;
  final ScrollController scrollController;
  final String currentUserId;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(MessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 80)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final message = widget.messages[index];
              final isMe = message.senderId == widget.currentUserId;
              final showTime =
                  index == widget.messages.length - 1 ||
                  _shouldShowTime(
                    widget.messages[index],
                    widget.messages[index + 1],
                  );

              return Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
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
                      theme: theme,
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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              );
            }, childCount: widget.messages.length),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
  // }

  bool _shouldShowTime(Message current, Message next) {
    if (current.senderId != next.senderId) {
      return true;
    }

    final timeDifference = next.createdAt!.difference(current.createdAt!);
    return timeDifference.inMinutes > 5;
  }
}
