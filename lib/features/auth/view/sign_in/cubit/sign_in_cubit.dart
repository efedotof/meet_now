import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/model/login/login.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';

part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required AuthInterface authInterface})
    : _authInterface = authInterface,
      super(SignInState.initial());

  final AuthInterface _authInterface;

  void check({
    required TextEditingController username,
    required TextEditingController password,
  }) {
    final un = username.text.trim();
    final pass = password.text.trim();

    if (un.isNotEmpty && pass.isNotEmpty) {
      emit(SignInState.noEmpty());
    }
  }

  Future<void> login({
    required BuildContext context,
    required TextEditingController username,
    required TextEditingController password,
  }) async {
    final un = username.text.trim();
    final pass = password.text.trim();

    if (un.isEmpty || pass.isEmpty) {
      debugPrint("nullldata");
      emit(const SignInState.error(error: 'Введите логин и пароль'));
      return;
    }
    emit(SignInState.loading());
    try {
      final loginData = Login(username: un, password: pass);
      final user = await _authInterface.login(login: loginData);
      debugPrint("user: user:$user      loginData: $loginData");
      emit(SignInState.success());
      debugPrint("Login successful, navigating to MainHomeRoute");
      if (context.mounted) {
        context.replaceRoute(const MainHomeRoute());
      }
    } catch (e) {
      emit(SignInState.error(error: e.toString()));
    }
  }
}
