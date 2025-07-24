import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/server/model/commands/commands_chat.dart';
import 'package:meet_now_app/server/model/user_activity/user_activity.dart';

import 'command_suggestions_widget.dart';
import 'send_button.dart';

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

  @override
  void initState() {
    super.initState();
    _suggestionsCubit = context.read<CommandSuggestionsCubit>();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _suggestionsCubit.showSuggestions(widget.controller.text);
  }

  void _handleSend() async {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;

    if (text.startsWith('/')) {
      final result = await _suggestionsCubit.executeCommand(text);
      widget.onCommandResult(result);
    } else {
      widget.onSend();
    }

    widget.controller.clear();
    _suggestionsCubit.hideSuggestions();
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: CommandSuggestionsWidget(controller: widget.controller),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText:
                            "Сообщение или команда (${CommandsChat.values.map((c) => c.command).join(', ')})",
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onChanged: (value) {
                        context.read<UserActivityCubit>().sendActivity(
                          type: ActivityType.TYPING,
                          chatId: widget.chatId,
                        );
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
    );
  }
}
