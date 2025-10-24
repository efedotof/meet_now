import 'package:flutter/material.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class SuggestionsCard extends StatelessWidget {
  const SuggestionsCard({
    super.key,
    required this.suggestions,
    required this.cubit,
    required this.controller,
  });

  final List<String> suggestions;
  final CommandSuggestionsCubit cubit;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).availableCommands,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                suggestions.map((command) {
                  return InputChip(
                    label: Text(command),
                    onPressed: () {
                      controller.text = command;
                      cubit.hideSuggestions();
                    },
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}