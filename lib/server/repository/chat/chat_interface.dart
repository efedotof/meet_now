import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/chat_constraint/chat_constraint.dart';
import 'package:meet_now_app/server/model/chat_game/chat_game.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'package:meet_now_app/server/model/user/user.dart';

abstract interface class ChatInterface {
  void init(String userId);
  void getActiveTemporary();
  void getChatPermanent();
  void dispose();
  Stream<List<TemporaryChat>> get temporaryChatStream;
  Stream<List<Chat>> get chatStream;
  Future<ChatConstraint> getConstraint({required TemporaryChat tempChat});
  Future<void> updateConstraint({required TemporaryChat tempChat});

  Future<List<ChatGame>> getGames({required Chat chat});
  Future<ChatGame> addGames({required Chat chat});
  Future<void> createTemporary({required User recipient});
  Future<void> finistTemporaryChat({required TemporaryChat tempChat});
  Future<void> agreeTemporary({required TemporaryChat tempChat});
}
