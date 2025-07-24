import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/commands/commands_chat.dart';
import 'package:meet_now_app/server/service/command_executor/command_executor_service.dart';

part 'command_suggestions_state.dart';
part 'command_suggestions_cubit.freezed.dart';

class CommandSuggestionsCubit extends Cubit<CommandSuggestionsState> {
  CommandSuggestionsCubit({required this.commandExecutorService})
    : super(CommandSuggestionsState.initial());

  final CommandExecutorService commandExecutorService;

  List<String> get availableCommands =>
      CommandsChat.values.map((cmd) => cmd.command).toList();

  void showSuggestions(String input) {
    if (!input.startsWith('/')) {
      emit(CommandSuggestionsState.hidden());
      return;
    }

    final query = input.substring(1).toLowerCase();
    final suggestions =
        availableCommands
            .where((cmd) => cmd.substring(1).toLowerCase().contains(query))
            .toList();

    if (suggestions.isEmpty) {
      emit(CommandSuggestionsState.hidden());
    } else {
      emit(CommandSuggestionsState.visible(suggestions: suggestions));
    }
  }

  void hideSuggestions() {
    emit(CommandSuggestionsState.hidden());
  }

  void clearSearchResults() {
    emit(CommandSuggestionsState.hidden());
  }

  Future<String> executeCommand(String commandText) async {
    final parts = commandText.split(' ');
    final command = CommandsChat.fromString(parts[0]);
    final argument = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    if (command == null) return "Неизвестная команда: ${parts[0]}";

    final result = await commandExecutorService.execute(command, argument);
    if (command == CommandsChat.icebSearch && result.searchResults != null) {
      emit(
        CommandSuggestionsState.searchResults(results: result.searchResults!),
      );
    }

    return result.message;
  }
}
