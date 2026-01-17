import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'game_chat_state.dart';
part 'game_chat_cubit.freezed.dart';

class GameChatCubit extends Cubit<GameChatState> {
  final GamesInterface gamesRepository;
  final TokenInterface _tokenInterface;
  final UserInterface _userInterface;
  final UploadImageInterface _uploadImageInterface;
  GameChatCubit({
    required UserInterface userInterface,
    required this.gamesRepository,
    required TokenInterface tokenInterface,
    required UploadImageInterface uploadImageInterface,
  }) : _uploadImageInterface = uploadImageInterface,
       _userInterface = userInterface,
       _tokenInterface = tokenInterface,
       super(const GameChatState.initial());

  final Map<String, String> _thumbUrlCache = {};

  Future<void> fetchGames() async {
    emit(const GameChatState.loading());

    try {
      final games = await gamesRepository.getAllGame();

      final processedGames = await _processGamesThumbnails(games);

      emit(GameChatState.loaded(games: processedGames));
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

  Future<List<GameResponse>> _processGamesThumbnails(
    List<GameResponse> games,
  ) async {
    final List<GameResponse> processed = [];

    for (final game in games) {
      try {
        String originalUrl = game.thumbnailUrl;

        if (originalUrl.isEmpty) {
          processed.add(game);
          continue;
        }

        if (!_thumbUrlCache.containsKey(originalUrl)) {
          final presignedUrl = await _uploadImageInterface.getPresignedUrl(
            originalUrl,
          );
          _thumbUrlCache[originalUrl] = presignedUrl;
        }

        processed.add(
          game.copyWith(thumbnailUrl: _thumbUrlCache[originalUrl]!),
        );
      } catch (e) {
        processed.add(game);
      }
    }

    return processed;
  }

  Future<void> refreshUser() async {
    await _userInterface.getUser();
  }
}
