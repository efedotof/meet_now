import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/model/login/login.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:meet_now_app/storage/password/password_storage_interface.dart';
import 'package:meet_now_app/storage/user/user_storage_interface.dart';

part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required UserStorageInterface userStorageInterface,
    required PasswordStorageInterface passwordStorageInterface,
    required AuthInterface authInterface,
    required UserModelAppInterface userModelAppInterface,
  }) : _authInterface = authInterface,
       _passwordStorageInterface = passwordStorageInterface,
       _userStorageInterface = userStorageInterface,
       _userModelAppInterface = userModelAppInterface,
       super(SplashState.initial());

  final UserStorageInterface _userStorageInterface;
  final PasswordStorageInterface _passwordStorageInterface;
  final AuthInterface _authInterface;
  final UserModelAppInterface _userModelAppInterface;

  Future<void> checkAutoLogin({required BuildContext context}) async {
    try {
      final user = await _userStorageInterface.getUser();
      final password = _passwordStorageInterface.getPassword();

      if (user != null && password.isNotEmpty) {
        final login = Login(username: user.username, password: password);
        final responseUser = await _authInterface.login(login: login);

        if (responseUser.id.isNotEmpty) {
          await _passwordStorageInterface.setPassword(password: password);
          await _userStorageInterface.saveUser(responseUser);
          _userModelAppInterface.user = responseUser;

          if (context.mounted) {
            context.pushRoute(const MainHomeRoute());
          }
        } else {
          if (context.mounted) {
            context.pushRoute(const AuthRoute());
          }
        }
      }
    } catch (e) {
      debugPrint('Ошибка авто-входа: $e');

      if (e.toString().contains("Пароль не установлен")) {
        if (context.mounted) {
          context.pushRoute(const AuthRoute());
        }
      } else {
        if (context.mounted) {
          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text('Ошибка авто-входа: $e')));
          context.pushRoute(const AuthRoute());
        }
      }
    }
  }
}
