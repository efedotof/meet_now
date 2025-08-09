import 'package:meet_now_app/server/model/chat_game/chat_game.dart';
import 'package:meet_now_app/server/model/game_response/game_response.dart';

abstract interface class GamesInterface {
  Future<List<ChatGame>> getGamesByChatIdOrAllGames({required String? chatId});
  Future<void> addGame({required String gameType, required String? chatId});
  Future<List<GameResponse>> getAllGame();
  Future<String?> getUrlGameByType({required String gameType});
}
