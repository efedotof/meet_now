part of 'pin_code_cubit.dart';

@freezed
abstract class PinCodeState with _$PinCodeState {
  const factory PinCodeState.initial() = _Initial;
  const factory PinCodeState.entering(String currentPin) = _Entering;
  const factory PinCodeState.processing() = _Processing;
  const factory PinCodeState.failure() = _Failure;
  const factory PinCodeState.authRequired() = _AuthRequired;
  const factory PinCodeState.mainHomeRequired() = _MainHomeRequired;
  const factory PinCodeState.locked(String blockReason) = _Locked;
}
