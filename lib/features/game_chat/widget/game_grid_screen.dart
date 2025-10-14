import 'package:flutter/material.dart';
import 'package:meet_now_app/features/friends/widget/empty_state.dart';
import 'package:meet_now_app/server/model/game_response/game_response.dart';

import 'game_card.dart';

class GamesGrid extends StatelessWidget {
  final List<GameResponse> games;

  const GamesGrid({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return EmptyState(theme: Theme.of(context));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GameCard(game: game);
        },
      ),
    );
  }
}
