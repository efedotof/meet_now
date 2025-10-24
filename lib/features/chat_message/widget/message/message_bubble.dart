import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/message/message.dart';

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
      padding = const EdgeInsets.all(0);
    } else if (message.isImage || message.isVideo) {
      padding = const EdgeInsets.all(8);
    } else if (message.isFile) {
      padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    } else {
      padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }

    Color? color =
        message.isSticker
            ? Colors.transparent
            : (isMe ? theme.colorScheme.primary : theme.cardTheme.color);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              border:
                  message.isSticker
                      ? null
                      : Border.all(color: theme.dividerColor),
            ),
            child: MessageContent(message: message, isMe: isMe, theme: theme),
          ),
        ),
      ],
    );
  }
}
