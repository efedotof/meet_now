import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required UserInterface userInterface,
    required UserModelAppInterface userModelAppInterface,
    required PasswordStorageInterface passwordStorageInterface,
    required UserStorageInterface userStorageInterface,
    required FCMServiceInterface fcmServiceInterface,
  }) : _fcmServiceInterface = fcmServiceInterface,
       _userInterface = userInterface,
       _userModelAppInterface = userModelAppInterface,
       _userStorageInterface = userStorageInterface,
       _passwordStorageInterface = passwordStorageInterface,
       super(SettingsState.initial()) {
    getCurrentUser();
  }
  final UserModelAppInterface _userModelAppInterface;
  final PasswordStorageInterface _passwordStorageInterface;
  final UserStorageInterface _userStorageInterface;
  final UserInterface _userInterface;

  final FCMServiceInterface _fcmServiceInterface;

  Future<void> exit({required BuildContext context}) async {
    _userStorageInterface.clearUser();
    _userModelAppInterface.user = null;
    _passwordStorageInterface.clearPassword();
    _fcmServiceInterface.deleteFCMToken();
    if (context.mounted) {
      context.replaceRoute(AuthRoute());
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _userInterface.getUser();
      _userModelAppInterface.user = user;
    } catch (e) {
      //
    }
  }
}
