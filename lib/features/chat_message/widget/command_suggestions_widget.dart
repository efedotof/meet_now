import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';

class CommandSuggestionsWidget extends StatelessWidget {
  const CommandSuggestionsWidget({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommandSuggestionsCubit, CommandSuggestionsState>(
      builder: (context, state) {
        return state.maybeMap(
          visible:
              (state) => Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.suggestions.length,
                  itemBuilder: (context, index) {
                    final command = state.suggestions[index];
                    return ListTile(
                      title: Text(
                        command,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      dense: true,
                      onTap: () {
                        controller.text = '$command ';
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        context
                            .read<CommandSuggestionsCubit>()
                            .hideSuggestions();
                      },
                    );
                  },
                ),
              ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
