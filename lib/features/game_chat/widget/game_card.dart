import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_chat_cubit.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/game_response/game_response.dart';
import 'game_web_view_screen.dart';

class GameCard extends StatefulWidget {
  const GameCard({super.key, required this.game, this.chatId});
  final GameResponse game;
  final String? chatId;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> with WidgetsBindingObserver {
  bool _isMobileLayout = false;
  static const double mobileBreakpoint = 768;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      _checkLayout();
    }
  }

  void _checkLayout() {
    final double width = MediaQuery.of(context).size.width;
    final bool newIsMobileLayout = width < mobileBreakpoint;

    if (mounted && _isMobileLayout != newIsMobileLayout) {
      setState(() {
        _isMobileLayout = newIsMobileLayout;
      });
    }
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
      final url = await cubit.getUrlGameByType(game.gameType, widget.chatId);

      if (context.mounted) {
        Navigator.of(context).pop();

        if (url != null && url.isNotEmpty) {
          final isWebOrWindows = kIsWeb || Platform.isWindows;

          if (isWebOrWindows) {
            // Для веба и Windows открываем в браузере
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
              webOnlyWindowName: '_blank',
            );

            // Обновляем очки через задержку
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                final pointsCubit = context.read<GamePointsCubit>();
                pointsCubit.refreshPoints();
              }
            });
          } else {
            // Для мобильных открываем в WebView
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });

    final cardBg = const Color(0xFFF5F7FA);
    final chipBg = const Color(0xFFE8EEF5);
    final textPrimary = const Color(0xFF1C1F26);

    bool isDesktopPlatform = false;
    if (!kIsWeb) {
      isDesktopPlatform =
          Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    }

    final double cardSizeMultiplier =
        ((kIsWeb || isDesktopPlatform) && !_isMobileLayout) ? 0.1 : 0.28;

    return InkWell(
      onTap: () => _onGameTap(context, widget.game),
      child: Container(
        width: MediaQuery.of(context).size.width * cardSizeMultiplier,
        height: MediaQuery.of(context).size.width * cardSizeMultiplier,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  widget.game.thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: widget.game.thumbnailUrl,
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
                                size: 32,
                              ),
                            ),
                      )
                      : const Center(
                        child: Icon(
                          Icons.sports_esports_outlined,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
            ),
            Positioned(
              left: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.game.gameName,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
