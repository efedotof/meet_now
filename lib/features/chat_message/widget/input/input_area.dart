import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';

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
    this.onContinueChat,
    this.onReportUser,
    this.onAddTimeChat,
    required this.recipientId,
    required this.tempChatId,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAddAttach;
  final Function(String) onCommandResult;
  final Function(Sticker) onStickerSelected;
  final String chatId;
  final bool isTemporary;
  final VoidCallback? onContinueChat;
  final VoidCallback? onReportUser;
  final VoidCallback? onAddTimeChat;
  final String recipientId;
  final String tempChatId;

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  late final CommandSuggestionsCubit _suggestionsCubit;
  late final StickerCubit _stickerCubit;
  final FocusNode _textFieldFocusNode = FocusNode();
  final DeviceMediaLibrary _mediaLibrary = DeviceMediaLibrary();
  final Map<String, Uint8List?> _thumbnailCache = {};
  final GlobalKey _menuKey = GlobalKey();

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

  void _onTempMenu() async {
    final buttonContext = _menuKey.currentContext;
    if (buttonContext == null) {
      return;
    }

    final buttonRenderObject = buttonContext.findRenderObject();
    if (buttonRenderObject == null || buttonRenderObject is! RenderBox) {
      return;
    }

    final button = buttonRenderObject;

    final overlayState = Overlay.of(context);

    final overlayContext = overlayState.context;
    final overlayRenderObject = overlayContext.findRenderObject();
    if (overlayRenderObject == null || overlayRenderObject is! RenderBox) {
      return;
    }

    final overlay = overlayRenderObject;
    final buttonTopRight = button.localToGlobal(
      button.size.topRight(Offset.zero),
      ancestor: overlay,
    );

    button.localToGlobal(
      button.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );

    int itemCount = 0;
    if (widget.isTemporary && widget.onAddTimeChat != null) itemCount++;
    if (widget.isTemporary && widget.onContinueChat != null) itemCount++;
    if (widget.onReportUser != null) itemCount++;

    final menuHeight = itemCount * 48.0;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(buttonTopRight.dx - 180, buttonTopRight.dy - menuHeight - 20),

        Offset(buttonTopRight.dx, buttonTopRight.dy - 10),
      ),
      Offset.zero & overlay.size,
    );

    final theme = Theme.of(context);
    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        if (widget.isTemporary && widget.onAddTimeChat != null)
          PopupMenuItem<String>(
            value: 'add_timer_time',
            child: Row(
              children: [
                Icon(Icons.punch_clock, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  S.of(context).add_time,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),

        if (widget.isTemporary && widget.onContinueChat != null)
          PopupMenuItem<String>(
            value: 'continue_chat',
            child: Row(
              children: [
                Icon(Icons.access_time, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  S.of(context).continue_the_chat,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),

        if (widget.onReportUser != null)
          PopupMenuItem<String>(
            value: 'report_user',
            child: Row(
              children: [
                Icon(Icons.flag_outlined, color: theme.colorScheme.error),
                const SizedBox(width: 12),
                Text(
                  S.of(context).reportuser,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value != null) _handleMenuAction(value);
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'add_timer_time':
        widget.onAddTimeChat?.call();
      case 'continue_chat':
        widget.onContinueChat?.call();
        break;
      case 'report_user':
        _showReportUserDialog();
        break;
    }
  }

  void _showReportUserDialog() {
    final commentController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(S.of(context).reportuser),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).reportuserdescription),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).selectreason,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ..._getReportReasons().map(
                          (reason) => RadioListTile<String>(
                            title: Text(reason),
                            value: reason,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            labelText: S.of(context).additionalcomments,
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(S.of(context).cancel),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              S
                                  .of(context)
                                  .please_select_the_reason_for_the_complaint,
                            ),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                        return;
                      },
                      child: Text(S.of(context).submitreport),
                    ),
                  ],
                ),
          ),
    );
  }

  List<String> _getReportReasons() {
    return [
      S.of(context).spam,
      S.of(context).harassment,
      S.of(context).inappropriatecontent,
      S.of(context).fakeprofile,
      S.of(context).other,
    ];
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
            StickerPickerWidget(
              onStickerSelected: _handleStickerSelected,
              // recipientId: widget.recipientId,
              // chatId: widget.chatId,
              // tempChatId: widget.tempChatId,
            ),

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
              onTempMenu: _onTempMenu,
              menuKey: _menuKey,
            ),
          ],
        ),
      ),
    );
  }
}
