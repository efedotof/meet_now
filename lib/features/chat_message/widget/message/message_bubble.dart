import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/chats/message/message.dart';

import 'message_content.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final ThemeData theme;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;
    if (message.isSticker) {
      padding = const EdgeInsets.all(4);
    } else if (message.isImage || message.isVideo) {
      padding = const EdgeInsets.all(8);
    } else if (message.isFile) {
      padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    } else {
      padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }

    Color? color =
        message.isSticker
            ? Colors.transparent
            : (isMe
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 8),
                  bottomRight: Radius.circular(isMe ? 8 : 20),
                ),
                boxShadow: [
                  if (!message.isSticker)
                    BoxShadow(
                      color: Colors.black.withAlpha(1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: MessageContent(message: message, isMe: isMe, theme: theme),
            ),
          ),
        ],
      ),
    );
  }
}
