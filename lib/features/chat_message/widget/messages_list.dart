import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_now_app/server/model/message/message.dart';

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

    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage(
        //     isDark ? 'assets/chat_bg_dark.jpg' : 'assets/chat_bg_light.jpg',
        //   ),
        //   fit: BoxFit.cover,
        //   opacity: isDark ? 0.1 : 0.05,
        // ),
      ),
      child: ListView.builder(
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
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isMe
                                  ? theme.colorScheme.primary
                                  : theme.cardTheme.color,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 18),
                          ),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Text(
                          message.text,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isMe
                                    ? theme.scaffoldBackgroundColor
                                    : theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
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
        },
      ),
    );
  }
}
