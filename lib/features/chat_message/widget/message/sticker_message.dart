import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/message/message.dart';

import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';
import 'text_message.dart';

class StickerMessage extends StatefulWidget {
  final Message message;
  final ThemeData theme;
  final bool isMe;

  const StickerMessage({
    super.key,
    required this.message,
    required this.theme,
    required this.isMe,
  });

  @override
  State<StickerMessage> createState() => _StickerMessageState();
}

class _StickerMessageState extends State<StickerMessage> {
  late Future<String> _stickerUrlFuture;
  final Map<String, String> _urlCache = {};

  @override
  void initState() {
    super.initState();
    _stickerUrlFuture = _getStickerUrl();
  }

  Future<String> _getStickerUrl() async {
    final media = widget.message.firstMedia;
    if (media == null || media.mediaUrl!.isEmpty) {
      throw Exception('No media found for sticker');
    }

    if (_urlCache.containsKey(media.mediaUrl)) {
      return _urlCache[media.mediaUrl]!;
    }

    try {
      final uploadImageInterface = context.read<UploadImageInterface>();
      final presignedUrl = await uploadImageInterface.getPresignedUrl(
        media.mediaUrl!,
      );

      _urlCache[media.mediaUrl!] = presignedUrl;

      return presignedUrl;
    } catch (e) {
      debugPrint('Error getting sticker URL: $e');
      throw Exception('Failed to load sticker: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.theme.colorScheme.surfaceContainerHighest.withAlpha(40),
                widget.theme.colorScheme.surfaceContainerHighest.withAlpha(20),
              ],
            ),
          ),
          child: FutureBuilder<String>(
            future: _stickerUrlFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      widget.theme.colorScheme.primary,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: widget.theme.colorScheme.error,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).error,
                        style: widget.theme.textTheme.labelSmall?.copyWith(
                          color: widget.theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    snapshot.data!,
                    fit: BoxFit.contain,
                    width: 140,
                    height: 140,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_emotions_outlined,
                              size: 48,
                              color: widget.theme.colorScheme.onSurface
                                  .withAlpha(5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              S.of(context).sticker,
                              style: widget.theme.textTheme.labelSmall
                                  ?.copyWith(
                                    color: widget.theme.colorScheme.onSurface
                                        .withAlpha(5),
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Icon(
                    Icons.emoji_emotions_outlined,
                    size: 48,
                    color: widget.theme.colorScheme.onSurface.withAlpha(5),
                  ),
                );
              }
            },
          ),
        ),
        if (widget.message.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextMessage(
              message: widget.message,
              isMe: widget.isMe,
              theme: widget.theme,
            ),
          ),
      ],
    );
  }
}
