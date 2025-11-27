import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'game_chat_state.dart';
part 'game_chat_cubit.freezed.dart';

class GameChatCubit extends Cubit<GameChatState> {
  final GamesInterface gamesRepository;
  final TokenInterface _tokenInterface;
  final UserInterface _userInterface;

  GameChatCubit({
    required UserInterface userInterface,
    required this.gamesRepository,
    required TokenInterface tokenInterface,
  }) : _userInterface = userInterface, _tokenInterface = tokenInterface,
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


  Future<void> refreshUser() async {
   await _userInterface.getUser();
  }
}
