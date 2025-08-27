import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/friends_request/friend_request.dart';
import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';

abstract interface class StorageHiveInterface {
  Future<void> init();

  Box<Interest> get interestBox;
  Box<Purpose> get purposeBox;
  Box<Chat> get permChatBox;
  Box<TemporaryChat> get tempChatBox;
  Box<FriendRequest> get friendRequestBox;

  ValueListenable<Box<Interest>> get listenableInterestBox;
  ValueListenable<Box<Purpose>> get listenablePurposeBox;
  ValueListenable<Box<Chat>> get listenablePermChatBox;
  ValueListenable<Box<TemporaryChat>> get listenableTempChatBox;
  ValueListenable<Box<FriendRequest>> get listenableFriendRequestBox;

  Future<void> addInterestBox({required Interest item});
  Future<void> addAllInterestBox({required List<Interest> items});
  Future<void> updateInterestBox({required int index, required Interest item});
  Future<void> deleteInterestBox({required int index});
  Future<void> clearInterestBox();

  Future<void> addPurposeBox({required Purpose item});
  Future<void> addAllPurposeBox({required List<Purpose> items});
  Future<void> updatePurposeBox({required int index, required Purpose item});
  Future<void> deletePurposeBox({required int index});
  Future<void> clearPurposeBox();

  Future<void> addCachedTemporaryChat({required TemporaryChat tempChat});
  Future<void> addAllTemporaryChat({required List<TemporaryChat> tempChats});
  Future<void> deleteTemporaryChat({required int index, required TemporaryChat tempChat});
  Future<void> clearTemporaryChat();

  Future<void> addPermChat({required Chat chat});
  Future<void> addAllPermChat({required List<Chat> chats});
  Future<void> deletePermChat({required int index, required Chat chat});
  Future<void> clearPermChat();

  Future<void> clearAll();
}
