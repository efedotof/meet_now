import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/server/repository/purp_and_int/purp_and_interes_interface.dart';
import 'package:meet_now_app/storage/first_open_app/first_open_app_interface.dart';
import 'package:meet_now_app/storage/pincode/pincode_storage_interface.dart';

part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required FirstOpenAppInterface firstOpenAppInterface,
    required PurpAndInteresInterface purpAndInteresInterface,
    required PincodeStorageInterface pincodeStorageInterface,
    required AuthInterface authInterface,
  }) : _firstOpenAppInterface = firstOpenAppInterface,
       _purpAndInteresInterface = purpAndInteresInterface,
       _pincodeStorageInterface = pincodeStorageInterface,
       _authInterface = authInterface,
       super(SplashState.initial());

  final AuthInterface _authInterface;
  final PincodeStorageInterface _pincodeStorageInterface;
  final PurpAndInteresInterface _purpAndInteresInterface;
  final FirstOpenAppInterface _firstOpenAppInterface;

  Future<void> checkAutoLogin({required BuildContext context}) async {
    try {
      if (_firstOpenAppInterface.isFirstOpenApp()) {
        await _handleFirstLaunch(context);
      } else {
        await _handleRegularLaunch(context);
      }
    } catch (e) {
      debugPrint('Ошибка в checkAutoLogin: $e');
      if (context.mounted) context.replaceRoute(const AuthRoute());
    }
  }

  Future<void> _handleFirstLaunch(BuildContext context) async {
    try {
      await _purpAndInteresInterface.getAllInterest();
      await _purpAndInteresInterface.getAllPurpose();
      await _firstOpenAppInterface.setValue(value: false);

      if (context.mounted) await _handleRegularLaunch(context);
    } catch (e) {
      debugPrint('Ошибка при первом запуске: $e');
      if (context.mounted) context.replaceRoute(const AuthRoute());
    }
  }

  Future<void> _handleRegularLaunch(BuildContext context) async {
    try {
      final user = await _authInterface.autoLogin();
      if (!context.mounted) return;

      if (user == null) {
        debugPrint('Автологин не удался: пользователь null');
        context.replaceRoute(const AuthRoute());
        return;
      }

      String pinCode;
      try {
        pinCode = _pincodeStorageInterface.getPinCode();
      } catch (e) {
        debugPrint('Пинкод не установлен, переходим на главный экран');
        context.replaceRoute(const MainHomeRoute());
        return;
      }

      final hasPinCode = pinCode.isNotEmpty;

      if (hasPinCode) {
        debugPrint('Пинкод установлен, переходим на экран пинкода');
        context.replaceRoute(const PinCodeRoute());
      } else {
        debugPrint('Пинкод не установлен, переходим на главный экран');
        context.replaceRoute(const MainHomeRoute());
      }
    } catch (e) {
      debugPrint('Ошибка при обычном запуске: $e');
      if (context.mounted) context.replaceRoute(const AuthRoute());
    }
  }
}

