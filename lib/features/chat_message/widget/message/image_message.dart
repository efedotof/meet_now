import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app_server/model/message/message.dart';
import 'package:meet_now_app_server/model/message_media/message_media.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

import 'file_size_formatter.dart';
import 'text_message.dart';

class ImageMessage extends StatelessWidget {
  final Message message;
  final ThemeData theme;
  final MessageMedia media;

  const ImageMessage({
    super.key,
    required this.message,
    required this.theme,
    required this.media,
  });

  Future<String?> _getPresignedUrl(BuildContext context) async {
    if (media.mediaUrl == null || media.mediaUrl!.isEmpty) return null;
    return context.read<UploadImageInterface>().getPresignedUrl(
      media.mediaUrl!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTemp = message.id?.startsWith('temp') ?? false;

    return FutureBuilder<String?>(
      future: _getPresignedUrl(context),
      builder: (context, snapshot) {
        final url = snapshot.data;
        final hasUrl = url != null && url.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  if (isTemp && !hasUrl)
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 3),
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
                                  urlMedias:[url],
                                  
                                ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: url,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorWidget:
                            (context, error, stackTrace) => Container(
                              width: double.infinity,
                              height: 200,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported, size: 50),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
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
      },
    );
  }
}
