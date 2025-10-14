import 'dart:async';

import 'package:flutter/foundation.dart';
import "package:hive_ce_flutter/hive_flutter.dart";
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/friends_request/friend_request.dart';
import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/server/model/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';
import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';
import 'storage_hive_interface.dart';

class StorageHiveRepository implements StorageHiveInterface {
  Box<Interest>? _interestBox;
  Box<Purpose>? _purposeBox;
  Box<PermanentChatResponseDto>? _permChatBox;
  Box<TemporaryChat>? _tempChatBox;
  Box<FriendRequest>? _friendRequestBox;

  final Completer<void> _initializationCompleter = Completer<void>();

  @override
  Box<Interest> get interestBox {
    if (_interestBox == null || !_interestBox!.isOpen) {
      throw Exception("Interest box is not initialized or open");
    }
    return _interestBox!;
  }

  @override
  Box<Purpose> get purposeBox {
    if (_purposeBox == null || !_purposeBox!.isOpen) {
      throw Exception("Purpose box is not initialized or open");
    }
    return _purposeBox!;
  }

  @override
  Box<PermanentChatResponseDto> get permChatBox {
    if (_permChatBox == null || !_permChatBox!.isOpen) {
      throw Exception("Permanent chat box is not initialized or open");
    }
    return _permChatBox!;
  }

  @override
  Box<TemporaryChat> get tempChatBox {
    if (_tempChatBox == null || !_tempChatBox!.isOpen) {
      throw Exception("Temporary chat box is not initialized or open");
    }
    return _tempChatBox!;
  }

  @override
  Box<FriendRequest> get friendRequestBox{
    if(_friendRequestBox == null || !_friendRequestBox!.isOpen){
      throw Exception("Friend request box is not initialized or open");
    }
    return _friendRequestBox!;
  }


  @override
  ValueListenable<Box<Interest>> get listenableInterestBox {
    if (_interestBox == null || !_interestBox!.isOpen) {
      throw Exception("Interest box is not initialized or open");
    }
    return _interestBox!.listenable();
  }

  @override
  ValueListenable<Box<Purpose>> get listenablePurposeBox {
    if (_purposeBox == null || !_purposeBox!.isOpen) {
      throw Exception("Purpose box is not initialized or open");
    }
    return _purposeBox!.listenable();
  }

  @override
  ValueListenable<Box<PermanentChatResponseDto>> get listenablePermChatBox {
    if (_permChatBox == null || !_permChatBox!.isOpen) {
      throw Exception("Permanent chat box is not initialized or open");
    }
    return _permChatBox!.listenable();
  }

  @override
  ValueListenable<Box<TemporaryChat>> get listenableTempChatBox {
    if (_tempChatBox == null || !_tempChatBox!.isOpen) {
      throw Exception("Temporary chat box is not initialized or open");
    }
    return _tempChatBox!.listenable();
  }

  @override
  ValueListenable<Box<FriendRequest>> get listenableFriendRequestBox{
    if(_friendRequestBox == null || !_friendRequestBox!.isOpen){
      throw Exception("Friend request box is not initialized or open");
    }
    return _friendRequestBox!.listenable();
  }

  @override
  Future<void> init() async {
    if (_initializationCompleter.isCompleted) {
      return;
    }
    try {
      _interestBox = await Hive.openBox<Interest>('interest_box');
      _purposeBox = await Hive.openBox<Purpose>('purpose_box');
      _permChatBox = await Hive.openBox<PermanentChatResponseDto>('perm_chat_response_dto_box');
      _tempChatBox = await Hive.openBox<TemporaryChat>('temp_chat_box');
      _friendRequestBox = await Hive.openBox<FriendRequest>('friend_request');

      debugPrint("All Hive boxes initialized successfully");
      _initializationCompleter.complete();
    } catch (e) {
      debugPrint("Error initializing Hive boxes: $e");
      _initializationCompleter.completeError(e);
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initializationCompleter.isCompleted) {
      await init();
    }
    await _initializationCompleter.future;
  }

  @override
  Future<void> addInterestBox({required Interest item}) async {
    await _ensureInitialized();
    await _interestBox!.add(item);
    debugPrint('StorageRepository: Added item to interestBox => $item');
  }

  @override
  Future<void> addAllInterestBox({required List<Interest> items}) async {
    await _ensureInitialized();
    await _interestBox!.addAll(items);
    debugPrint('StorageRepository: Added ${items.length} items to interestBox');
  }

  @override
  Future<void> updateInterestBox({
    required int index,
    required Interest item,
  }) async {
    await _ensureInitialized();
    await _interestBox!.putAt(index, item);
    debugPrint(
      'StorageRepository: Updated interestBox at index $index => $item',
    );
  }

  @override
  Future<void> deleteInterestBox({required int index}) async {
    await _ensureInitialized();
    await _interestBox!.deleteAt(index);
    debugPrint(
      'StorageRepository: Deleted item from interestBox at index $index',
    );
  }

  @override
  Future<void> clearInterestBox() async {
    await _ensureInitialized();
    await _interestBox!.clear();
    debugPrint('StorageRepository: Cleared all items from interestBox');
  }

  @override
  Future<void> addPurposeBox({required Purpose item}) async {
    await _ensureInitialized();
    await _purposeBox!.add(item);
    debugPrint('StorageRepository: Added item to purposeBox => $item');
  }

  @override
  Future<void> addAllPurposeBox({required List<Purpose> items}) async {
    await _ensureInitialized();
    await _purposeBox!.addAll(items);
    debugPrint('StorageRepository: Added ${items.length} items to purposeBox');
  }

  @override
  Future<void> updatePurposeBox({
    required int index,
    required Purpose item,
  }) async {
    await _ensureInitialized();
    await _purposeBox!.putAt(index, item);
    debugPrint(
      'StorageRepository: Updated purposeBox at index $index => $item',
    );
  }

  @override
  Future<void> deletePurposeBox({required int index}) async {
    await _ensureInitialized();
    await _purposeBox!.deleteAt(index);
    debugPrint(
      'StorageRepository: Deleted item from purposeBox at index $index',
    );
  }

  @override
  Future<void> clearPurposeBox() async {
    await _ensureInitialized();
    await _purposeBox!.clear();
    debugPrint('StorageRepository: Cleared all items from purposeBox');
  }

  @override
  Future<void> addCachedTemporaryChat({required TemporaryChat tempChat}) async {
    await _ensureInitialized();
    await _tempChatBox!.add(tempChat);
    debugPrint('Added temporary chat: $tempChat');
  }

  @override
  Future<void> addAllTemporaryChat({
    required List<TemporaryChat> tempChats,
  }) async {
    await _ensureInitialized();
    await _tempChatBox!.addAll(tempChats);
    debugPrint('Added ${tempChats.length} temporary chats');
  }

  @override
  Future<void> deleteTemporaryChat({
    required int index,
    required TemporaryChat tempChat,
  }) async {
    await _ensureInitialized();
    await _tempChatBox!.deleteAt(index);
    debugPrint('Deleted temporary chat at index $index');
  }

  @override
  Future<void> clearTemporaryChat() async {
    await _ensureInitialized();
    await _tempChatBox!.clear();
    debugPrint('Cleared all temporary chats');
  }

  @override
  Future<void> addPermChat({required PermanentChatResponseDto chat}) async {
    await _ensureInitialized();
    await _permChatBox!.add(chat);
    debugPrint('Added permanent chat: $chat');
  }

  @override
  Future<void> addAllPermChat({required List<PermanentChatResponseDto> chats}) async {
    await _ensureInitialized();
    await _permChatBox!.addAll(chats);
    debugPrint('Added ${chats.length} permanent chats');
  }

  @override
  Future<void> deletePermChat({required int index, required Chat chat}) async {
    await _ensureInitialized();
    await _permChatBox!.deleteAt(index);
    debugPrint('Deleted permanent chat at index $index');
  }

  @override
  Future<void> clearPermChat() async {
    await _ensureInitialized();
    await _permChatBox!.clear();
    debugPrint('Cleared all permanent chats');
  }

  @override
  Future<void> clearAll() async {
    await clearInterestBox();
    await clearPurposeBox();
    await clearTemporaryChat();
    await clearPermChat();
  }

  Future<void> close() async {
    await _interestBox?.close();
    await _purposeBox?.close();
    await _tempChatBox?.close();
    await _permChatBox?.close();
  }
}
