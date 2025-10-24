import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/message/message.dart';

import 'text_message.dart';

class StickerMessage extends StatelessWidget {
  final Message message;
  final ThemeData theme;

  const StickerMessage({super.key, required this.message, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.emoji_emotions_outlined, size: 40),
        ),
        if (message.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextMessage(message: message, isMe: true, theme: theme),
          ),
      ],
    );
  }
}
