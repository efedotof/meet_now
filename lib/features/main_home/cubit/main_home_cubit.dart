import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/repository/user/user_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

part 'main_home_state.dart';
part 'main_home_cubit.freezed.dart';

class MainHomeCubit extends Cubit<MainHomeState> {
  MainHomeCubit({
    required this.userInterface,
    required this.userModelAppInterface,
  }) : super(MainHomeState.initial());
  final UserInterface userInterface;
  final UserModelAppInterface userModelAppInterface;

  Future<void> setOnline({
    required BuildContext context,
    required bool isOnline,
  }) async {
    final user = userModelAppInterface.user;
    if (user != null) {
      context.replaceRoute(AuthRoute());
    }
    final token = user!.token ?? "";
    final uuid = user.id;
    await userInterface.patchUserOnline(
      isOnline: isOnline,
      token: token,
      uuid: uuid,
    );
  }

  Future<void> getUser({required BuildContext context}) async {
    final user = await userInterface.getUser();
    if (user.id == "" && context.mounted) {
      context.replaceRoute(AuthRoute());
    }
    userModelAppInterface.user = user;
  }
}
