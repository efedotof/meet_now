import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';
import 'package:meet_now_app_server/model/social/commands/commands_chat.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';

import '../suggestions/command_suggestions_widget.dart';
import 'sticker_picker_widget.dart';
import 'input_bottom_bar.dart';
import 'media_preview_section.dart';

class InputArea extends StatefulWidget {
  const InputArea({
    required this.controller,
    required this.onSend,
    required this.onCommandResult,
    required this.chatId,
    required this.onAddAttach,
    required this.onStickerSelected,
    required this.isTemporary,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAddAttach;
  final Function(String) onCommandResult;
  final Function(Sticker) onStickerSelected;
  final String chatId;
  final bool isTemporary;

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

  void _handleSend() async {
    final text = widget.controller.text.trim();
    final hasSelectedMedia =
        context.read<MediaSelectionCubit>().hasSelectedMedia;
    if (text.isEmpty && !hasSelectedMedia) return;

    if (hasSelectedMedia) {
      final selectedMedia =
          context.read<MediaSelectionCubit>().state.selectedMedia;
      context.read<ChatMessageCubit>().sendMediaMessage(
        selectedMedia,
        text: text,
      );
      context.read<MediaSelectionCubit>().clearMedia();
    } else if (text.isNotEmpty) {
      if (text.startsWith('/')) {
        final result = await _suggestionsCubit.executeCommand(text);
        widget.onCommandResult(result);
      } else {
        widget.onSend();
        _suggestionsCubit.clearSearchResults();
      }
    }
    if (text.isNotEmpty && !text.startsWith('/')) widget.controller.clear();
  }

  void _handleStickerSelected(Sticker sticker) {
    widget.onStickerSelected(sticker);
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

            if (!widget.isTemporary)
              MediaPreviewSection(
                theme: theme,
                thumbnailCache: _thumbnailCache,
                mediaLibrary: _mediaLibrary,
              ),

            InputBottomBar(
              controller: widget.controller,
              chatId: widget.chatId,
              onAddAttach: widget.onAddAttach,
              onSend: _handleSend,
              stickerCubit: _stickerCubit,
              textFieldFocusNode: _textFieldFocusNode,
              isTemporary: widget.isTemporary,
            ),
          ],
        ),
      ),
    );
  }
}
