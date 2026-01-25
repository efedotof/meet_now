import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'main_home_state.dart';
part 'main_home_cubit.freezed.dart';

class MainHomeCubit extends Cubit<MainHomeState> {
  MainHomeCubit({
    required UserInterface userInterface,
    required StorageHiveInterface storageHiveInterface,
    required SocketServiceInterface socketServiceInterface,
  }) : _userInterface = userInterface,
       _storageHiveInterface = storageHiveInterface,
       _socketServiceInterface = socketServiceInterface,
       super(MainHomeState.initial()) {
    connect();
  }
  final SocketServiceInterface _socketServiceInterface;
  final StorageHiveInterface _storageHiveInterface;
  final UserInterface _userInterface;
  StreamSubscription? _newTempChatSubscription;
  StreamSubscription? _tempChatSubscription;
  StreamSubscription? _permChatSubscription;

  Future<void> connect() async {
    try {
      _tempChatSubscription = _socketServiceInterface.temporaryChatsStream
          .listen((temps) {
            _storageHiveInterface.addAllTemporaryChat(tempChats: temps);
          });

      _permChatSubscription = _socketServiceInterface.permanentChatsStream
          .listen((perms) {
            _storageHiveInterface.addAllPermChat(chats: perms);
          });

      await _userInterface.getUser();
    } catch (e) {
      //
    }
  }

  Future<void> getNewTempChat({required BuildContext context}) async {
    try {
      await _newTempChatSubscription?.cancel();

      _newTempChatSubscription = _socketServiceInterface.temporaryChatNewStream
          .listen((tempNewChat) {
            if (tempNewChat.tempChatId != "" && context.mounted) {
              context.pushRoute(
                ChatMessageRoute(temporaryChatModel: tempNewChat),
              );
            }
          });
    } catch (e) {
      //
    }
  }

  @override
  Future<void> close() {
    _tempChatSubscription?.cancel();
    _permChatSubscription?.cancel();
    _newTempChatSubscription?.cancel();
    return super.close();
  }
}
