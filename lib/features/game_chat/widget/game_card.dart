import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_chat_cubit.dart';
import 'package:meet_now_app_server/model/chats/game_response/game_response.dart';

import 'game_web_view_screen.dart';

class GameCard extends StatelessWidget {
  final GameResponse game;
  final String? chatId;

  const GameCard({super.key, required this.game, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _onGameTap(context, game),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child:
                    game.thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: game.thumbnailUrl,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.sports_esports_outlined,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                        )
                        : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.sports_esports_outlined,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      game.gameName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      game.gameDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withAlpha(1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        game.gameType,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onGameTap(BuildContext context, GameResponse game) async {
    final cubit = context.read<GameChatCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Подготовка игры...'),
              ],
            ),
          ),
    );

    try {
      final url = await cubit.getUrlGameByType(game.gameType, chatId);

      if (context.mounted) {
        Navigator.of(context).pop();

        if (url != null && url.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => GameWebViewScreen(url: url, gameName: game.gameName),
            ),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: const Text('Не удалось получить ссылку на игру'),
              action: SnackBarAction(label: 'Понятно', onPressed: () {}),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            action: SnackBarAction(label: 'Понятно', onPressed: () {}),
          ),
        );
      }
    }
  }
}
