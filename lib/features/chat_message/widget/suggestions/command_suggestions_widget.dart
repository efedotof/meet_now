import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/command_suggestions/command_suggestions_cubit.dart';
import '../search/searching_indicator.dart';
import 'suggestions_card.dart';
import '../search/search_results_widget.dart';

class CommandSuggestionsWidget extends StatelessWidget {
  final TextEditingController controller;

  const CommandSuggestionsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommandSuggestionsCubit, CommandSuggestionsState>(
      builder: (context, state) {
        final cubit = context.read<CommandSuggestionsCubit>();

        return state.when(
          initial: () => const SizedBox.shrink(),
          hidden: () => const SizedBox.shrink(),
          visible:
              (suggestions) => SuggestionsCard(
                suggestions: suggestions,
                cubit: cubit,
                controller: controller,
              ),
          searching: () => const SearchingIndicator(),
          searchResults:
              (results) =>
                  results.isEmpty
                      ? const SizedBox.shrink()
                      : SearchResultsWidget(
                        results: results,
                        controller: controller,
                        onClear: () => cubit.clearSearchResults(),
                      ),
        );
      },
    );
  }
}
