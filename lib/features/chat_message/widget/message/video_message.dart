import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/chats/message/message.dart';
import 'package:meet_now_app_server/model/chats/message_media/message_media.dart';
import 'file_size_formatter.dart';
import 'text_message.dart';

class VideoMessage extends StatelessWidget {
  final Message message;
  final ThemeData theme;
  final MessageMedia media;
  final bool isMe;

  const VideoMessage({
    super.key,
    required this.message,
    required this.theme,
    required this.media,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final hasThumb =
        media.thumbnailUrl != null && media.thumbnailUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surfaceContainerHighest,
                        theme.colorScheme.surfaceContainerHighest.withAlpha(7),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (hasThumb)
                        CachedNetworkImage(
                          imageUrl: media.thumbnailUrl!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(4),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (media.fileSize != null)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        FileSizeFormatter.format(media.fileSize!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (message.text.isNotEmpty) ...[
          const SizedBox(height: 12),
          TextMessage(message: message, isMe: isMe, theme: theme),
        ],
      ],
    );
  }
}
