import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/message/message.dart';

import 'file_message.dart';
import 'image_message.dart';
import 'sticker_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class MessageContent extends StatelessWidget {
  final Message message;
  final bool isMe;
  final ThemeData theme;

  const MessageContent({
    super.key,
    required this.message,
    required this.isMe,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final hasMedia = message.media.isNotEmpty;
    final media = hasMedia ? message.media.first : null;

    if (message.isSticker) {
      return StickerMessage(message: message, theme: theme);
    } else if (message.isImage && hasMedia) {
      return ImageMessage(message: message, theme: theme, media: media!);
    } else if (message.isVideo && hasMedia) {
      return VideoMessage(message: message, theme: theme, media: media!);
    } else if (message.isFile && hasMedia) {
      return FileMessage(theme: theme, media: media!);
    } else {
      return TextMessage(message: message, isMe: isMe, theme: theme);
    }
  }
}
