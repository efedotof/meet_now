import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/message_media/message_media.dart';

import 'file_size_formatter.dart';

class FileMessage extends StatelessWidget {
  final ThemeData theme;
  final MessageMedia media;

  const FileMessage({super.key, required this.theme, required this.media});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.insert_drive_file;
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
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).scaffoldBackgroundColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),),
                if (media.fileSize != null)
                  Text(
                    FileSizeFormatter.format(media.fileSize!),
                    style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
                  ),
              ],
            ),
          ),
          Icon(Icons.download, color: Theme.of(context).scaffoldBackgroundColor, size: 20),
        ],
      ),
    );
  }
}
