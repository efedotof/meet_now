import 'package:flutter/material.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ChoiceChip(
            label: Text(suggestions[index]),
            selected: false,
            onSelected: (_) {
              controller.text = suggestions[index];
              cubit.hideSuggestions();
            },
          );
        },
      ),
    );
  }
}
