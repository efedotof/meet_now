import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/storage/pincode/pincode_storage_interface.dart';

part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required PincodeStorageInterface pincodeStorageInterface,
    required AuthInterface authInterface,
  }) : _pincodeStorageInterface = pincodeStorageInterface,
       _authInterface = authInterface,

       super(SplashState.initial());

  final AuthInterface _authInterface;
  final PincodeStorageInterface _pincodeStorageInterface;

  Future<void> checkAutoLogin({required BuildContext context}) async {
    try {
      final code = _pincodeStorageInterface.getPinCode();
      if (code != '') {
        if (context.mounted) {
          context.replaceRoute(const PinCodeRoute());
        }
      }

      final user = await _authInterface.autoLogin();

      if (user == null) {
        if (context.mounted) {
          context.replaceRoute(const AuthRoute());
        }
      } else {
        if (context.mounted) {
          context.replaceRoute(const MainHomeRoute());
        }
      }
    } catch (e) {
      debugPrint('Ошибка авто-входа: $e');

      if (e.toString().contains("Пароль не установлен")) {
        if (context.mounted) {
          context.replaceRoute(const AuthRoute());
        }
      } else {
        if (context.mounted) {
          context.replaceRoute(const AuthRoute());
        }
      }
    }
  }
}
