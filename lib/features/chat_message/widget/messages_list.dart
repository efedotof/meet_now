import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_now_app_server/model/message/message.dart';
import 'message/message_bubble.dart';

class MessagesList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == currentUserId;
        final showTime =
            index == messages.length - 1 ||
            messages[index + 1].senderId != message.senderId;

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
              child: MessageBubble(message: message, isMe: isMe, theme: theme),
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
      },
    );
  }
}
