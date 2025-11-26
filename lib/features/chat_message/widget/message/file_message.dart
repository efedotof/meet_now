import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/chats/message_media/message_media.dart';
import 'dart:math' as math;

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
    IconData icon = Icons.insert_drive_file;
    Color iconColor = isMe ? Colors.white : theme.colorScheme.primary;

    if (media.mimeType != null) {
      if (media.mimeType!.contains('pdf')) {
        icon = Icons.picture_as_pdf;
      } else if (media.mimeType!.contains('word') ||
          media.mimeType!.contains('document')) {
        icon = Icons.description;
      } else if (media.mimeType!.contains('excel') ||
          media.mimeType!.contains('spreadsheet')) {
        icon = Icons.table_chart;
      } else if (media.mimeType!.contains('zip') ||
          media.mimeType!.contains('rar')) {
        icon = Icons.archive;
      } else if (media.mimeType!.contains('audio')) {
        icon = Icons.audio_file;
      }
    }

    final uri = Uri.tryParse(media.mediaUrl ?? '');
    final name =
        (uri != null && uri.pathSegments.isNotEmpty)
            ? uri.pathSegments.last
            : 'Файл';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isMe
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: iconColor),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (media.fileSize != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(media.fileSize!),
                    style: TextStyle(
                      color:
                          isMe
                              ? Colors.white70
                              : theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.download,
            color: isMe ? Colors.white : theme.colorScheme.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}

double log(num x) => math.log(x);
double pow(num x, num exponent) => math.pow(x, exponent).toDouble();
