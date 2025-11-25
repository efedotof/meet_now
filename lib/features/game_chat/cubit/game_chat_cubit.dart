import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/chats/game_response/game_response.dart';

import 'package:meet_now_app_server/repository/games/games_interface.dart';
import 'package:meet_now_app_server/storage/token/token_interface.dart';

part 'game_chat_state.dart';
part 'game_chat_cubit.freezed.dart';

class GameChatCubit extends Cubit<GameChatState> {
  final GamesInterface gamesRepository;
  final TokenInterface _tokenInterface;

  GameChatCubit({
    required this.gamesRepository,
    required TokenInterface tokenInterface,
  }) : _tokenInterface = tokenInterface,
       super(const GameChatState.initial());

  Future<void> fetchGames() async {
    emit(const GameChatState.loading());
    try {
      final games = await gamesRepository.getAllGame();
      emit(GameChatState.loaded(games: games));
    } catch (e) {
      emit(GameChatState.error(message: e.toString()));
    }
  }

  Future<String?> getUrlGameByType(String gameType, String? chatId) async {
    try {
      final baseUrl = await gamesRepository.getUrlGameByType(
        gameType: gameType,
      );
      if (baseUrl == null) return null;

      final token = _tokenInterface.getToken();
      if (token == "") return null;

      final uri = Uri.parse(baseUrl);
      final newUri = uri.replace(
        queryParameters: {'token': token, 'chatId': chatId},
      );

      return newUri.toString();
    } catch (e) {
      rethrow;
    }
  }
}
