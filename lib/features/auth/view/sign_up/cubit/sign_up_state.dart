part of 'sign_up_cubit.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;
  const factory SignUpState.loading() = _Loading;
  const factory SignUpState.success() = _Success;
  const factory SignUpState.error({required String error}) = _Error;
  const factory SignUpState.avatarLoading() = _AvatarLoading;
  const factory SignUpState.avatarLoaded() = _AvatarLoaded;
}
