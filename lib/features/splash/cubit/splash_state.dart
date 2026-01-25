part of 'splash_cubit.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = _Initial;
  const factory SplashState.navigateToAuth() = _NavigateToAuth;
  const factory SplashState.navigateToLocked({required String blockReason}) =
      _NavigateToLocked;
  const factory SplashState.navigateToUploadAvatar() = _NavigateToUploadAvatar;
  const factory SplashState.navigateToPinCode() = _NavigateToPinCode;
  const factory SplashState.navigateToMainHome() = _NavigateToMainHome;
}
