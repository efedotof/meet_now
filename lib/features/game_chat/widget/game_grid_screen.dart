import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/chats/game_response/game_response.dart';
import 'empty_state_widget.dart';
import 'game_card.dart';

class GamesGrid extends StatelessWidget {
  final List<GameResponse> games;
  final String? chatId;

  const GamesGrid({super.key, required this.games, required this.chatId});

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return EmptyStateWidget();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: List.generate(games.length, (index) {
          final game = games[index];
          return GameCard(game: game, chatId: chatId);
        }),
      ),
    );
  }
}
