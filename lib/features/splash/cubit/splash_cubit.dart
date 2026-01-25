import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/auth/auth_interface.dart';
import 'package:meet_now_app_server/repository/purp_and_int/purp_and_interes_interface.dart';
import 'package:meet_now_app_server/storage/first_open_app/first_open_app_interface.dart';
import 'package:meet_now_app_server/storage/pincode/pincode_storage_interface.dart';

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
       super(const SplashState.initial());

  final AuthInterface _authInterface;
  final PincodeStorageInterface _pincodeStorageInterface;
  final PurpAndInteresInterface _purpAndInteresInterface;
  final FirstOpenAppInterface _firstOpenAppInterface;

  Future<void> checkAutoLogin() async {
    try {
      if (_firstOpenAppInterface.isFirstOpenApp()) {
        await _handleFirstLaunch();
      } else {
        await _handleRegularLaunch();
      }
    } catch (e) {
      emit(const SplashState.navigateToAuth());
    }
  }

  Future<void> _handleFirstLaunch() async {
    try {
      await _purpAndInteresInterface.getAllInterest();
      await _purpAndInteresInterface.getAllPurpose();
      await _firstOpenAppInterface.setValue(value: false);

      await _handleRegularLaunch();
    } catch (e) {
      emit(const SplashState.navigateToAuth());
    }
  }

  Future<void> _handleRegularLaunch() async {
    try {
      final user = await _authInterface.autoLogin();

      if (user == null) {
        emit(const SplashState.navigateToAuth());
        return;
      }

      if (user.isBlocked == true) {
        if (user.blockReason != null && user.blockReason != "") {
          emit(SplashState.navigateToLocked(blockReason: user.blockReason!));
        } else {
          emit(SplashState.navigateToLocked(blockReason: ""));
        }

        return;
      }

      final hasAvatar = user.avatar != null && user.avatar!.isNotEmpty;
      if (!hasAvatar) {
        emit(const SplashState.navigateToUploadAvatar());
        return;
      }

      String pinCode;
      try {
        pinCode = _pincodeStorageInterface.getPinCode();
      } catch (e) {
        emit(const SplashState.navigateToMainHome());
        return;
      }

      final hasPinCode = pinCode.isNotEmpty;

      if (hasPinCode) {
        emit(const SplashState.navigateToPinCode());
      } else {
        emit(const SplashState.navigateToMainHome());
      }
    } catch (e) {
      emit(const SplashState.navigateToAuth());
    }
  }
}
