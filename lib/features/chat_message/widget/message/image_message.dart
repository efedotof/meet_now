import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app_server/model/chats/message/message.dart';
import 'package:meet_now_app_server/model/chats/message_media/message_media.dart';

import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';
import 'file_size_formatter.dart';
import 'text_message.dart';

class ImageMessage extends StatefulWidget {
  final Message message;
  final ThemeData theme;
  final MessageMedia media;
  final bool isMe;

  const ImageMessage({
    super.key,
    required this.message,
    required this.theme,
    required this.media,
    required this.isMe,
  });

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  static final Map<String, String> _urlCache = {};
  late Future<String?> _presignedUrlFuture;

  @override
  void initState() {
    super.initState();
    _presignedUrlFuture = _getPresignedUrl();
  }

  Future<String?> _getPresignedUrl() async {
    if (widget.media.mediaUrl == null || widget.media.mediaUrl!.isEmpty) {
      return null;
    }

    if (_urlCache.containsKey(widget.media.mediaUrl)) {
      return _urlCache[widget.media.mediaUrl];
    }

    try {
      final uploadImageInterface = context.read<UploadImageInterface>();
      final presignedUrl = await uploadImageInterface.getPresignedUrl(
        widget.media.mediaUrl!,
      );

      _urlCache[widget.media.mediaUrl!] = presignedUrl;

      return presignedUrl;
    } catch (e) {
      debugPrint('Error getting presigned URL: $e');
      return null;
    }
  }

  void _clearCache() {
    _urlCache.remove(widget.media.mediaUrl);
  }

  @override
  Widget build(BuildContext context) {
    final isTemp = widget.message.id?.startsWith('temp') ?? false;

    return FutureBuilder<String?>(
      future: _presignedUrlFuture,
      builder: (context, snapshot) {
        final url = snapshot.data;
        final hasUrl = url != null && url.isNotEmpty;

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
                    if (isTemp && !hasUrl)
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.theme.colorScheme.surfaceContainerHighest,
                              widget.theme.colorScheme.surfaceContainerHighest
                                  .withAlpha(7),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                widget.theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Загрузка...',
                              style: TextStyle(
                                color:
                                    widget.theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (hasUrl)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => FullscreenMediaView(
                                    urlMedia: true,
                                    showSelectionIndicator: false,
                                    urlMedias: [url],
                                  ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: url,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          cacheKey: widget.media.mediaUrl,
                          maxWidthDiskCache: 1000,
                          maxHeightDiskCache: 1000,
                          memCacheHeight: 440,
                          memCacheWidth: 440,
                          placeholder:
                              (context, url) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      widget
                                          .theme
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      widget
                                          .theme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withAlpha(7),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      widget.theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _clearCache();
                              if (mounted) {
                                setState(() {
                                  _presignedUrlFuture = _getPresignedUrl();
                                });
                              }
                            });

                            return Container(
                              width: double.infinity,
                              height: 220,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    widget.theme.colorScheme.errorContainer,
                                    widget.theme.colorScheme.errorContainer
                                        .withAlpha(7),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image_rounded,
                                    size: 48,
                                    color:
                                        widget
                                            .theme
                                            .colorScheme
                                            .onErrorContainer,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ошибка загрузки',
                                    style: TextStyle(
                                      color:
                                          widget
                                              .theme
                                              .colorScheme
                                              .onErrorContainer,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.theme.colorScheme.surfaceContainerHighest,
                              widget.theme.colorScheme.surfaceContainerHighest
                                  .withAlpha(7),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_rounded,
                              size: 48,
                              color: widget.theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Изображение недоступно',
                              style: TextStyle(
                                color:
                                    widget.theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.media.fileSize != null)
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
                            FileSizeFormatter.format(widget.media.fileSize!),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (hasUrl)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fullscreen_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (widget.message.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              TextMessage(
                message: widget.message,
                isMe: widget.isMe,
                theme: widget.theme,
              ),
            ],
          ],
        );
      },
    );
  }
}
