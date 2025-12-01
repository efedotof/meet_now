import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/widget/widget.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_chat_cubit.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class GameChatScreen extends StatefulWidget {
  final String? chatId;

  const GameChatScreen({super.key, this.chatId});

  @override
  State<GameChatScreen> createState() => _GameChatScreenState();
}

class _GameChatScreenState extends State<GameChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameChatCubit>().fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [Color(0xFFD8E3E7), Color(0xFFC8D5DA), Color(0xFFD8E3E7)],
        stops: [0.1, 0.5, 0.9],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [0.0, 0.2, 0.5, 0.8, 1],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Игры'),
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            BlocBuilder<GameChatCubit, GameChatState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () => context.pushRoute(GiftRoute()),
                  child: Text(
                    "${context.read<UserModelAppInterface>().user!.gamePoints} points",
                  ),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _onRefresh(),
          child: BlocBuilder<GameChatCubit, GameChatState>(
            builder: (context, state) {
              return state.when(
                initial: () => const GamesSkeleton(),
                loading: () => const GamesSkeleton(),
                loaded:
                    (games) => GamesGrid(games: games, chatId: widget.chatId),
                error: (message) => ErrorsWidget(message: message),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<GameChatCubit>().fetchGames();
    context.read<GameChatCubit>().refreshUser();
  }
}
