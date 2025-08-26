import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';

part 'main_home_state.dart';
part 'main_home_cubit.freezed.dart';

class MainHomeCubit extends Cubit<MainHomeState> {
  MainHomeCubit({required SocketServiceInterface socketServiceInterface})
    : _socketServiceInterface = socketServiceInterface,
      super(MainHomeState.initial()) {
    connect();
  }
  final SocketServiceInterface _socketServiceInterface;

  StreamSubscription? _newTempChatSubscription;

  Future<void> connect() async {
    try {
      _socketServiceInterface.connect();
      _socketServiceInterface.getActiveTemporary();
      _socketServiceInterface.getPermanent();
    } catch (e) {
      debugPrint("error to connect: $e");
    }
  }

  Future<void> getNewTempChat({required BuildContext context}) async {
    try {
      await _newTempChatSubscription?.cancel();
      
      _newTempChatSubscription = _socketServiceInterface.temporaryChatNewStream.listen((tempNewChat) {
        if (tempNewChat.tempChatId != "" && context.mounted) {
          context.pushRoute(ChatMessageRoute(temporaryChatModel: tempNewChat));
        }
      });
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
    }
  }

  @override
  Future<void> close() {
    _newTempChatSubscription?.cancel();
    return super.close();
  }
}