import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommandSuggestionsCubit, CommandSuggestionsState>(
      builder: (context, state) {
        return state.when(
          initial:
              () => IconButton(
                icon: const Icon(Icons.send),
                onPressed: onPressed,
              ),
          visible:
              (suggestions) =>
                  IconButton(icon: const Icon(Icons.send), onPressed: () {}),
          hidden:
              () => IconButton(
                icon: const Icon(Icons.send),
                onPressed: onPressed,
              ),
          searchResults:
              (results) =>
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        );
      },
    );
  }
}
