import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/chats/message_media/message_media.dart';

import 'file_size_formatter.dart';

class FileMessage extends StatelessWidget {
  final ThemeData theme;
  final MessageMedia media;
  final bool isMe;

  const FileMessage({
    super.key,
    required this.theme,
    required this.media,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.insert_drive_file_rounded;
    Color iconColor = isMe ? Colors.white : theme.colorScheme.primary;

    if (media.mimeType != null) {
      if (media.mimeType!.contains('pdf')) {
        icon = Icons.picture_as_pdf_rounded;
        iconColor = isMe ? Colors.red.shade100 : Colors.red;
      } else if (media.mimeType!.contains('word') ||
          media.mimeType!.contains('document')) {
        icon = Icons.description_rounded;
        iconColor = isMe ? Colors.blue.shade100 : Colors.blue;
      } else if (media.mimeType!.contains('excel') ||
          media.mimeType!.contains('spreadsheet')) {
        icon = Icons.table_chart_rounded;
        iconColor = isMe ? Colors.green.shade100 : Colors.green;
      } else if (media.mimeType!.contains('zip') ||
          media.mimeType!.contains('rar')) {
        icon = Icons.archive_rounded;
        iconColor = isMe ? Colors.orange.shade100 : Colors.orange;
      } else if (media.mimeType!.contains('audio')) {
        icon = Icons.audio_file_rounded;
        iconColor = isMe ? Colors.purple.shade100 : Colors.purple;
      }
    }

    final uri = Uri.tryParse(media.mediaUrl ?? '');
    final name =
        (uri != null && uri.pathSegments.isNotEmpty)
            ? uri.pathSegments.last
            : 'Файл';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isMe
                ? theme.colorScheme.primary.withAlpha(9)
                : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.white.withAlpha(2) : iconColor.withAlpha(1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: isMe ? Colors.white : iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isMe ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (media.fileSize != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    FileSizeFormatter.format(media.fileSize!),
                    style: TextStyle(
                      color:
                          isMe
                              ? Colors.white70
                              : theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
                  isMe
                      ? Colors.white.withAlpha(2)
                      : theme.colorScheme.primary.withAlpha(1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.download_rounded,
              color: isMe ? Colors.white : theme.colorScheme.primary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
