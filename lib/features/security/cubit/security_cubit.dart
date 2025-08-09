import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/storage/pincode/pincode_storage_interface.dart';

part 'security_state.dart';
part 'security_cubit.freezed.dart';

class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit({required PincodeStorageInterface pincodeStorageInterface})
    : _pincodeStorageInterface = pincodeStorageInterface,
      super(SecurityState.initial());
  final PincodeStorageInterface _pincodeStorageInterface;

  void togglePin(bool value) => emit(state.copyWith(pinEnabled: value));
  void toggleBiometric(bool value) =>
      emit(state.copyWith(biometricEnabled: value));
  void togglePrivacyMode(bool value) =>
      emit(state.copyWith(privacyMode: value));
  void toggleAutoLock(bool value) => emit(state.copyWith(autoLock: value));
  void setPinSetInProgress(bool value) =>
      emit(state.copyWith(pinSetInProgress: value));

  bool hasPinCode() {
    try {
      return _pincodeStorageInterface.getPinCode().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  bool verifyPin(String pincode) {
    try {
      return _pincodeStorageInterface.getPinCode() == pincode;
    } catch (e) {
      return false;
    }
  }

  void setPinCode({required String pincode}) {
    _pincodeStorageInterface.setPinCode(pincode: pincode);
  }
}
