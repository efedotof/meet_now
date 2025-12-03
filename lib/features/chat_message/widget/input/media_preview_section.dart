import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';

import 'media_thumbnail.dart';

class MediaPreviewSection extends StatelessWidget {
  const MediaPreviewSection({
    required this.theme,
    required this.thumbnailCache,
    required this.mediaLibrary,
    super.key,
  });

  final ThemeData theme;
  final Map<String, Uint8List?> thumbnailCache;
  final DeviceMediaLibrary mediaLibrary;

  Future<Uint8List?> _loadThumbnail(MediaItem mediaItem) async {
    if (thumbnailCache.containsKey(mediaItem.id)) {
      return thumbnailCache[mediaItem.id];
    }
    try {
      final thumbnail = await mediaLibrary.getThumbnail(
        mediaId: mediaItem.id,
        mediaType: mediaItem.type,
        width: 200,
        height: 200,
      );
      if (thumbnail != null) thumbnailCache[mediaItem.id] = thumbnail;
      return thumbnail;
    } catch (_) {
      return null;
    }
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return minutes > 0
        ? '$minutes:${seconds.toString().padLeft(2, '0')}'
        : seconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<MediaSelectionCubit, MediaSelectionState>(
      builder: (context, state) {
        if (state.selectedMedia.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black87 : Colors.white70,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Выбрано медиа: ${state.selectedMedia.length}',
                //   style: theme.textTheme.bodySmall?.copyWith(
                //     color: theme.colorScheme.onSurfaceVariant,
                //   ),
                // ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.selectedMedia.length,
                    itemBuilder: (context, index) {
                      final mediaItem = state.selectedMedia[index];
                      return MediaThumbnail(
                        mediaItem: mediaItem,
                        loadThumbnail: _loadThumbnail,
                        formatDuration: _formatDuration,
                        theme: theme,
                        onRemove:
                            () => context
                                .read<MediaSelectionCubit>()
                                .removeMedia(mediaItem),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
