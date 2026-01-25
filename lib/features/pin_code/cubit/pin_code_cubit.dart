import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/auth/auth_interface.dart';
import 'package:meet_now_app_server/storage/pincode/pincode_storage_interface.dart';

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

  void addDigit({required String digit, required String currentPin}) async {
    String correctPin = _pincodeStorageInterface.getPinCode();
    final newPin = currentPin + digit;

    if (newPin.length < 4) {
      emit(PinCodeState.entering(newPin));
    } else {
      if (newPin == correctPin) {
        emit(PinCodeState.processing());
        try {
          final user = await _authInterface.autoLogin();

          if (user == null) {
            emit(const PinCodeState.authRequired());
          } else {
            if (user.isBlocked == true) {
              emit(PinCodeState.locked(user.blockReason ?? ''));
            } else {
              emit(const PinCodeState.mainHomeRequired());
            }
          }
        } catch (e) {
          if (e.toString().contains("Пароль не установлен")) {
            emit(const PinCodeState.authRequired());
          } else {
            emit(const PinCodeState.authRequired());
          }
        }
      } else {
        emit(const PinCodeState.failure());
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
    emit(const PinCodeState.initial());
  }
}
