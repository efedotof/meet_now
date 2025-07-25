import 'package:flutter/material.dart';
import 'package:meet_now_app/server/model/commands/command_result.dart';
import 'package:meet_now_app/server/model/commands/commands_chat.dart';
import 'package:meet_now_app/server/repository/icebreaker/icebreaker_interface.dart';

class CommandExecutorService {
  final IcebreakerInterface icebreakerInterface;

  CommandExecutorService({required this.icebreakerInterface});

  Future<List<String>> searchIcebreakers(String text) async {
    try {
      if (text.isEmpty) return [];
      final list = await icebreakerInterface.textSearch(text: text);
      return list.map((e) => e.text).toList();
    } catch (e) {
      debugPrint("Ошибка поиска: ${e.toString()}");
      return [];
    }
  }

  Future<CommandResult> execute(CommandsChat command, String argument) async {
    switch (command) {
      case CommandsChat.icebSearch:
        return _handleIcebCommand(argument);
      case CommandsChat.games:
        return _handleChatgameCommand(argument);
      case CommandsChat.icebGetAll:
        return _handleGetAllCommand();
      case CommandsChat.icebRandom:
        return _handlerIcebRandomCommand();
    }
  }

  Future<CommandResult> _handleIcebCommand(String argument) async {
    try {
      if (argument.isEmpty) return CommandResult("Введите тему для обсуждения");
      final list = await icebreakerInterface.textSearch(text: argument);
      return CommandResult(
        list.map((e) => e.text).join('\n'),
        searchResults: list.map((e) => e.text).toList(),
      );
    } catch (e) {
      return CommandResult("Ошибка выполнения команды: ${e.toString()}");
    }
  }

  Future<CommandResult> _handleChatgameCommand(String argument) {
    return Future.value(CommandResult("Игра начата: $argument"));
  }

  Future<CommandResult> _handleGetAllCommand() {
    return Future.value(CommandResult("Все icebreaker"));
  }

  Future<CommandResult> _handlerIcebRandomCommand() async {
    try {
      final iceb = await icebreakerInterface.getRandomIce();
      if (iceb != null) {
        return CommandResult(iceb.text);
      } else {
        return CommandResult(
          "Интересно получается, в небе птицы, а на земле люди...",
        );
      }
    } catch (e) {
      return CommandResult("Тук-тук");
    }
  }
}
