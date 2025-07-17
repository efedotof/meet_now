import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.userModelAppInterface,
    required this.passwordStorageInterface,
    required this.userStorageInterface,
  }) : super(SettingsState.initial());
  final UserModelAppInterface userModelAppInterface;
  final PasswordStorageInterface passwordStorageInterface;
  final UserStorageInterface userStorageInterface;

  Future<void> exit({required BuildContext context}) async {
    userStorageInterface.clearUser();
    userModelAppInterface.user = null;
    passwordStorageInterface.clearPassword();
    if (context.mounted) {
      context.replaceRoute(AuthRoute());
    }
  }
}
