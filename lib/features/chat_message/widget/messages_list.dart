import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_now_app/server/model/message/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meet_now_app/server/model/message_media/message_media.dart';

import 'file_size_formatter.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.currentUserId,
  });

  final List<Message> messages;
  final ScrollController scrollController;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isMe = message.senderId == currentUserId;

          final showTime =
              index == messages.length - 1 ||
              messages[index + 1].senderId != message.senderId;

          return Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: isMe ? 60 : 16,
                  right: isMe ? 16 : 60,
                  top: 4,
                  bottom: showTime ? 4 : 8,
                ),
                child: _MessageBubble(
                  message: message,
                  isMe: isMe,
                  theme: theme,
                ),
              ),
              if (showTime)
                Padding(
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 16,
                    right: isMe ? 16 : 0,
                    bottom: 16,
                  ),
                  child: Text(
                    DateFormat.Hm().format(message.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final ThemeData theme;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: _getContentPadding(),
            decoration: BoxDecoration(
              color: _getBubbleColor(),
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
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  EdgeInsets _getContentPadding() {
    if (message.isSticker) {
      return const EdgeInsets.all(0);
    } else if (message.isImage || message.isVideo) {
      return const EdgeInsets.all(8);
    } else if (message.isFile) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  Color? _getBubbleColor() {
    if (message.isSticker) return Colors.transparent;
    return isMe ? theme.colorScheme.primary : theme.cardTheme.color;
  }

  Widget _buildContent() {
    // Для сообщений с медиа используем первый медиа-элемент
    final hasMedia = message.media.isNotEmpty;
    final firstMedia = hasMedia ? message.media.first : null;

    if (message.isSticker) {
      return _buildStickerContent(firstMedia);
    } else if (message.isImage && hasMedia) {
      return _buildImageContent(firstMedia!);
    } else if (message.isVideo && hasMedia) {
      return _buildVideoContent(firstMedia!);
    } else if (message.isFile && hasMedia) {
      return _buildFileContent(firstMedia!);
    } else {
      return _buildTextContent();
    }
  }

  Widget _buildStickerContent(MessageMedia? media) {
    // TODO: Реализовать отображение стикеров когда будет модель Sticker
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
        if (message.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildTextContent(),
        ],
      ],
    );
  }

  Widget _buildImageContent(MessageMedia media) {
    final isTemp = message.id?.startsWith('temp') ?? false;
    final hasMediaUrl = media.mediaUrl != null && media.mediaUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (isTemp && !hasMediaUrl)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Загрузка...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              else if (hasMediaUrl)
                CachedNetworkImage(
                  imageUrl: media.mediaUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.photo, size: 40),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: theme.colorScheme.onErrorContainer,
                        ),
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
        if (message.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildTextContent(),
        ],
      ],
    );
  }

  Widget _buildVideoContent(MessageMedia media) {
    final isTemp = message.id?.startsWith('temp') ?? false;
    final hasMediaUrl = media.mediaUrl != null && media.mediaUrl!.isNotEmpty;
    final hasThumbnail =
        media.thumbnailUrl != null && media.thumbnailUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    if (hasThumbnail)
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
                          Icons.play_circle_filled,
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
        if (message.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildTextContent(),
        ],
      ],
    );
  }

  Widget _buildFileContent(MessageMedia media) {
    final icon = _getFileIcon(media.mimeType);
    final fileName = _getFileNameFromUrl(media.mediaUrl);

    return InkWell(
      onTap: () {
        // TODO: Обработка нажатия на файл (скачивание/просмотр)
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (media.fileSize != null)
                    Text(
                      FileSizeFormatter.format(media.fileSize!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.download, color: theme.colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
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

  IconData _getFileIcon(String? mimeType) {
    if (mimeType == null) return Icons.insert_drive_file;

    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('word') || mimeType.contains('document')) {
      return Icons.description;
    }
    if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) {
      return Icons.table_chart;
    }
    if (mimeType.contains('zip') || mimeType.contains('rar')) {
      return Icons.archive;
    }
    if (mimeType.contains('audio')) return Icons.audio_file;

    return Icons.insert_drive_file;
  }

  String _getFileNameFromUrl(String? url) {
    if (url == null) return 'Файл';
    final uri = Uri.tryParse(url);
    if (uri != null) {
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
    }
    return 'Файл';
  }
}
