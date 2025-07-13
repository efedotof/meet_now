import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';

part 'chat_game.freezed.dart';
part 'chat_game.g.dart';

@freezed
abstract class ChatGame with _$ChatGame {
  const factory ChatGame({
    required String id,
    required Chat chat,
    required String gameType,
    required String state,
  }) = _ChatGame;

  factory ChatGame.fromJson(Map<String, dynamic> json) =>
      _$ChatGameFromJson(json);
}
