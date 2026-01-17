import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_chat_cubit.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/game_response/game_response.dart';

import 'game_web_view_screen.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game, this.chatId});
  final GameResponse game;
  final String? chatId;

  @override
  Widget build(BuildContext context) {
    final cardBg = const Color(0xFFF5F7FA);
    final chipBg = const Color(0xFFE8EEF5);
    final textPrimary = const Color(0xFF1C1F26);

    return InkWell(
      onTap: () => _onGameTap(context, game),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: MediaQuery.of(context).size.width * 0.42,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  game.thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: game.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) => const Center(
                              child: Icon(
                                Icons.sports_esports_outlined,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                      )
                      : const Center(
                        child: Icon(
                          Icons.sports_esports_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
            ),

            Positioned(
              left: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  game.gameName,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
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
          (context) => AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(S.of(context).game_preparation),
              ],
            ),
          ),
    );

    try {
      final url = await cubit.getUrlGameByType(game.gameType, chatId);

      if (context.mounted) {
        Navigator.of(context).pop();

        if (url != null && url.isNotEmpty) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => GameWebViewScreen(url: url, gameName: game.gameName),
            ),
          );

          if (context.mounted) {
            final pointsCubit = context.read<GamePointsCubit>();
            await pointsCubit.refreshPoints();
          }
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(S.of(context).couldnt_get_the_link_to_the_game),
              action: SnackBarAction(
                label: S.of(context).clear,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error}: $e'),
            action: SnackBarAction(
              label: S.of(context).clear,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }
}
