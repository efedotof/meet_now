import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/message/message.dart';

class TextMessage extends StatelessWidget {
  final Message message;
  final bool isMe;
  final ThemeData theme;

  const TextMessage({
    super.key,
    required this.message,
    required this.isMe,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      message.text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color:
            message.isSticker
                ? theme.colorScheme.onSurface
                : (isMe
                    ? theme.scaffoldBackgroundColor
                    : theme.colorScheme.primary),
      ),
    );
  }
}
