// features/chat_message/widget/input_area.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
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
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final Function(String) onCommandResult;
  final String chatId;

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  late final CommandSuggestionsCubit _suggestionsCubit;
  late final StickerCubit _stickerCubit;

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
    if (text.isEmpty) return;

    if (text.startsWith('/')) {
      final result = await _suggestionsCubit.executeCommand(text);
      widget.onCommandResult(result);
    } else {
      widget.onSend();
      _suggestionsCubit.clearSearchResults();
    }

    widget.controller.clear();
  }

  void _handleStickerSelected(String sticker) {
    widget.controller.text = sticker;
    _handleSend();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.3,
                    ),
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
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: widget.controller,
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
}
