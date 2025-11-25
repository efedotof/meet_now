import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/widget/widget.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_chat_cubit.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Игры'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.pushRoute(GiftRoute()),
            child: Text(
              "${context.read<UserModelAppInterface>().user!.gamePoints} points",
            ),
          ),
        ],
      ),
      body: BlocBuilder<GameChatCubit, GameChatState>(
        builder: (context, state) {
          return state.when(
            initial: () => LoadingWidget(),
            loading: () => LoadingWidget(),
            loaded: (games) => GamesGrid(games: games, chatId: widget.chatId),
            error: (message) => ErrorsWidget(message: message),
          );
        },
      ),
    );
  }
}
