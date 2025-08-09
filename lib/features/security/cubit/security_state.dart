part of 'security_cubit.dart';

@freezed
abstract class SecurityState with _$SecurityState {
  const factory SecurityState({
    required bool pinEnabled,
    required bool biometricEnabled,
    required bool privacyMode,
    required bool autoLock,
    @Default(false) bool pinSetInProgress,
  }) = _SecurityState;

  factory SecurityState.initial() => const SecurityState(
    pinEnabled: false,
    biometricEnabled: false,
    privacyMode: false,
    autoLock: true,
  );
}
