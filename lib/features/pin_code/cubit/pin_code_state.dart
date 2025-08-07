part of 'pin_code_cubit.dart';

@freezed
abstract class PinCodeState with _$PinCodeState {
  const factory PinCodeState.initial() = _Initial;
  const factory PinCodeState.entering(String currentPin) = _Entering;
  const factory PinCodeState.success() = _Success;
  const factory PinCodeState.failure(String error) = _Failure;
  const factory PinCodeState.reset() = _Reset;
}
