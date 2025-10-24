import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/game_response/game_response.dart';
import 'package:meet_now_app_server/repository/games/games_interface.dart';

part 'game_chat_state.dart';
part 'game_chat_cubit.freezed.dart';

class GameChatCubit extends Cubit<GameChatState> {
  final GamesInterface gamesRepository;

  GameChatCubit({required this.gamesRepository})
    : super(const GameChatState.initial());

  Future<void> fetchGames() async {
    emit(const GameChatState.loading());
    try {
      final games = await gamesRepository.getAllGame();
      emit(GameChatState.loaded(games: games));
    } catch (e) {
      emit(GameChatState.error(message: e.toString()));
    }
  }

  Future<String?> getUrlGameByType(String gameType) async {
    try {
      return await gamesRepository.getUrlGameByType(gameType: gameType);
    } catch (e) {
      rethrow;
    }
  }
}
