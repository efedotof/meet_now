import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/social/commands/commands_chat.dart';

import 'package:meet_now_app_server/service/command_executor/command_executor_service.dart';

part 'command_suggestions_state.dart';
part 'command_suggestions_cubit.freezed.dart';

class CommandSuggestionsCubit extends Cubit<CommandSuggestionsState> {
  CommandSuggestionsCubit({required this.commandExecutorService})
    : super(CommandSuggestionsState.initial());

  final CommandExecutorService commandExecutorService;

  List<String> get availableCommands =>
      CommandsChat.values.map((cmd) => cmd.command).toList();
  Timer? _debounceTimer;

  void showSuggestionsVisible(String input) {
    if (input == '/') {
      emit(CommandSuggestionsState.visible(suggestions: availableCommands));
      return;
    }
  }

  void showSuggestions(String input) {
    _debounceTimer?.cancel();
    if (input == '/') {
      emit(CommandSuggestionsState.visible(suggestions: availableCommands));
      return;
    }

    if (!input.startsWith('/')) {
      emit(CommandSuggestionsState.hidden());
      return;
    }

    if (input.startsWith('${CommandsChat.icebSearch.command} ')) {
      final argument = input.substring(
        CommandsChat.icebSearch.command.length + 1,
      );
      if (argument.isNotEmpty) {
        emit(CommandSuggestionsState.searching());

        _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
          final results = await commandExecutorService.searchIcebreakers(
            argument,
          );
          if (isClosed) return;
          emit(CommandSuggestionsState.searchResults(results: results));
        });
        return;
      }
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

    debugPrint("command: $command argument: $argument");

    if (command == null) return "Неизвестная команда: ${parts[0]}";

    final result = await commandExecutorService.execute(command, argument);
    debugPrint("result: $result");
    if (command == CommandsChat.icebSearch && result.searchResults != null) {
      emit(
        CommandSuggestionsState.searchResults(results: result.searchResults!),
      );
    }

    return result.message;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
