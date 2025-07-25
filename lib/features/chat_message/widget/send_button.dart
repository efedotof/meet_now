import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CommandSuggestionsCubit, CommandSuggestionsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary,
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: IconButton(
            icon: state.when(
              initial:
                  () => Icon(Icons.send, color: theme.colorScheme.onPrimary),
              visible:
                  (suggestions) =>
                      Icon(Icons.send, color: theme.colorScheme.onPrimary),
              hidden:
                  () => Icon(Icons.send, color: theme.colorScheme.onPrimary),
              searching:
                  () => SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
              searchResults:
                  (results) =>
                      Icon(Icons.search, color: theme.colorScheme.onPrimary),
            ),
            onPressed: state.maybeWhen(
              searching: () => null,
              orElse: () => onPressed,
            ),
          ),
        );
      },
    );
  }
}
