import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/server/model/commands/commands_chat.dart';
import 'package:meet_now_app/server/model/user_activity/user_activity.dart';

import 'command_suggestions_widget.dart';
import 'send_button.dart';
import 'sticker_picker_widget.dart';

class InputArea extends StatefulWidget {
  const InputArea({
    required this.controller,
    required this.onSend,
    required this.onCommandResult,
    required this.chatId,
    required this.onAddAttach,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAddAttach;
  final Function(String) onCommandResult;
  final String chatId;

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  late final CommandSuggestionsCubit _suggestionsCubit;
  late final StickerCubit _stickerCubit;
  final FocusNode _textFieldFocusNode = FocusNode();
  final DeviceMediaLibrary _mediaLibrary = DeviceMediaLibrary();
  final Map<String, Uint8List?> _thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    _suggestionsCubit = context.read<CommandSuggestionsCubit>();
    _stickerCubit = context.read<StickerCubit>();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    _suggestionsCubit.showSuggestions(text);

    if (!text.startsWith('${CommandsChat.icebSearch.command} ')) {
      _suggestionsCubit.clearSearchResults();
    }
  }

  // void _handleSend() async {
  //   final text = widget.controller.text.trim();
  //   final hasSelectedMedia =
  //       context.read<MediaSelectionCubit>().hasSelectedMedia;

  //   if (text.isEmpty && !hasSelectedMedia) return;

  //   if (text.startsWith('/')) {
  //     final result = await _suggestionsCubit.executeCommand(text);
  //     widget.onCommandResult(result);
  //   } else {
  //     widget.onSend();
  //     _suggestionsCubit.clearSearchResults();
  //   }

  //   if (!text.startsWith('/')) {
  //     widget.controller.clear();
  //   }
  // }

  // В классе _InputAreaState обновите метод _handleSend:

  void _handleSend() async {
    final text = widget.controller.text.trim();
    final hasSelectedMedia =
        context.read<MediaSelectionCubit>().hasSelectedMedia;

    if (text.isEmpty && !hasSelectedMedia) return;

    if (hasSelectedMedia) {
      // Отправляем медиа через ChatMessageCubit
      final selectedMedia =
          context.read<MediaSelectionCubit>().state.selectedMedia;
      context.read<ChatMessageCubit>().sendMediaMessage(
        selectedMedia,
        text: text,
      );

      // Очищаем выбранные медиа после отправки
      context.read<MediaSelectionCubit>().clearMedia();
    } else if (text.isNotEmpty) {
      // Отправляем текстовое сообщение
      if (text.startsWith('/')) {
        final result = await _suggestionsCubit.executeCommand(text);
        widget.onCommandResult(result);
      } else {
        widget.onSend();
        _suggestionsCubit.clearSearchResults();
      }
    }

    if (text.isNotEmpty && !text.startsWith('/')) {
      widget.controller.clear();
    }
  }

  void _handleStickerSelected(String sticker) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;

    final safeStart = start.clamp(0, text.length);
    final safeEnd = end.clamp(0, text.length);

    final newText = text.replaceRange(safeStart, safeEnd, sticker);
    widget.controller.text = newText;

    final newCursorPosition = safeStart + sticker.length;
    widget.controller.selection = TextSelection.collapsed(
      offset: newCursorPosition,
    );

    FocusScope.of(context).requestFocus(_textFieldFocusNode);
  }

  void _removeMediaItem(MediaItem mediaItem) {
    context.read<MediaSelectionCubit>().removeMedia(mediaItem);
    _thumbnailCache.remove(mediaItem.id);
  }

  Future<Uint8List?> _loadThumbnail(MediaItem mediaItem) async {
    if (_thumbnailCache.containsKey(mediaItem.id)) {
      return _thumbnailCache[mediaItem.id];
    }

    try {
      final thumbnail = await _mediaLibrary.getThumbnail(
        mediaId: mediaItem.id,
        mediaType: mediaItem.type,
        width: 200,
        height: 200,
      );

      if (thumbnail != null) {
        _thumbnailCache[mediaItem.id] = thumbnail;
      }

      return thumbnail;
    } catch (e) {
      debugPrint('Error loading thumbnail for preview: $e');
      return null;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _textFieldFocusNode.dispose();
    _thumbnailCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _suggestionsCubit,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            CommandSuggestionsWidget(controller: widget.controller),
            StickerPickerWidget(onStickerSelected: _handleStickerSelected),
            _buildSelectedMediaPreview(theme),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outlineVariant.withAlpha(1),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: widget.onAddAttach,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withAlpha(5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _textFieldFocusNode,
                        decoration: InputDecoration(
                          hintText: S.of(context).messageHint,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          suffixIcon: BlocBuilder<StickerCubit, StickerState>(
                            builder: (context, stickerState) {
                              return IconButton(
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: stickerState.maybeWhen(
                                    visible: () => theme.colorScheme.primary,
                                    orElse:
                                        () =>
                                            theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                onPressed: () {
                                  _stickerCubit.toggleStickers();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        ),
                        onChanged: (value) {
                          context.read<UserActivityCubit>().sendActivity(
                            type: ActivityType.TYPING,
                            chatId: widget.chatId,
                          );
                          context
                              .read<CommandSuggestionsCubit>()
                              .showSuggestionsVisible(value);
                        },
                        style: theme.textTheme.bodyMedium,
                        minLines: 1,
                        maxLines: 5,
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SendButton(onPressed: _handleSend),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedMediaPreview(ThemeData theme) {
    return BlocBuilder<MediaSelectionCubit, MediaSelectionState>(
      builder: (context, state) {
        if (state.selectedMedia.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выбрано медиа: ${state.selectedMedia.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.selectedMedia.length,
                  itemBuilder: (context, index) {
                    final mediaItem = state.selectedMedia[index];
                    return _buildMediaThumbnail(
                      mediaItem: mediaItem,
                      theme: theme,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaThumbnail({
    required MediaItem mediaItem,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surfaceContainerHigh,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildMediaContent(mediaItem, theme),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeMediaItem(mediaItem),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withAlpha(9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(MediaItem mediaItem, ThemeData theme) {
    return FutureBuilder<Uint8List?>(
      future: _loadThumbnail(mediaItem),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FullScreenMediaView(
                          mediaItems: [mediaItem],
                          initialIndex: 0,
                          selectedItems: [mediaItem],
                          onItemSelected: (media, value) {},
                          showSelectionIndicators: false,
                        ),
                  ),
                ),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            ),
          );
        }

        return Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  mediaItem.type == 'video' ? Icons.videocam : Icons.photo,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                if (mediaItem.type == 'video')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatDuration(mediaItem.duration ?? 0),
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else {
      return seconds.toString();
    }
  }
}
