import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return BlocBuilder<CommandSuggestionsCubit, CommandSuggestionsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? Colors.black87 : Colors.white70,
          ),
          padding: EdgeInsets.all(6),
          child: GestureDetector(
            onTap: state.maybeWhen(
              searching: () => null,
              orElse: () => onPressed,
            ),
            child: state.when(
              initial:
                  () => Icon(
                    Icons.send,
                    color: isDark ? Colors.white : Colors.black,
                  ),
              hidden:
                  () => Icon(
                    Icons.send,
                    color: isDark ? Colors.white : Colors.black,
                  ),
              visible:
                  (suggestions) => Icon(
                    Icons.send,
                    color: isDark ? Colors.white : Colors.black,
                  ),
              searching:
                  () => SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
              searchResults:
                  (results) => Icon(
                    Icons.search,
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
          ),
        );
      },
    );
  }
}
