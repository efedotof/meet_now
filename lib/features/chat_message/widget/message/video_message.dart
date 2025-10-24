import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/message/message.dart';
import 'package:meet_now_app_server/model/message_media/message_media.dart';

import 'file_size_formatter.dart';
import 'text_message.dart';

class VideoMessage extends StatelessWidget {
  final Message message;
  final ThemeData theme;
  final MessageMedia media;

  const VideoMessage({
    super.key,
    required this.message,
    required this.theme,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    final hasThumb =
        media.thumbnailUrl != null && media.thumbnailUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                height: 200,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Stack(
                  children: [
                    if (hasThumb)
                      CachedNetworkImage(
                        imageUrl: media.thumbnailUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    Container(
                      color: Colors.black38,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (media.fileSize != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      FileSizeFormatter.format(media.fileSize!),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (message.text.isNotEmpty) const SizedBox(height: 8),
        if (message.text.isNotEmpty)
          TextMessage(message: message, isMe: true, theme: theme),
      ],
    );
  }
}
