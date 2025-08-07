import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app/server/repository/auth/auth_interface.dart';
import 'package:meet_now_app/storage/pincode/pincode_storage_interface.dart';

part 'pin_code_state.dart';
part 'pin_code_cubit.freezed.dart';

class PinCodeCubit extends Cubit<PinCodeState> {
  PinCodeCubit({
    required AuthInterface authInterface,
    required PincodeStorageInterface pincodeStorageInterface,
  }) : _authInterface = authInterface,
       _pincodeStorageInterface = pincodeStorageInterface,
       super(PinCodeState.initial());
  final PincodeStorageInterface _pincodeStorageInterface;
  final AuthInterface _authInterface;
  void addDigit({
    required BuildContext context,
    required String digit,
    required String currentPin,
  }) async {
    String correctPin = _pincodeStorageInterface.getPinCode();
    final newPin = currentPin + digit;

    if (newPin.length < 4) {
      emit(PinCodeState.entering(newPin));
    } else {
      if (newPin == correctPin) {
        try {
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
        emit(PinCodeState.success());
      } else {
        emit(PinCodeState.failure(S.of(context).incorrectPinCode));
        Future.delayed(const Duration(seconds: 1), reset);
      }
    }
  }

  void backspace(String currentPin) {
    if (currentPin.isNotEmpty) {
      emit(
        PinCodeState.entering(currentPin.substring(0, currentPin.length - 1)),
      );
    }
  }

  void reset() {
    emit(const PinCodeState.reset());
    emit(const PinCodeState.initial());
  }
}
