part of 'uploads_avatars_cubit.dart';

@freezed
class UploadsAvatarsState with _$UploadsAvatarsState {
  const factory UploadsAvatarsState.initial() = _Initial;
  const factory UploadsAvatarsState.loading() = _Loading;
  const factory UploadsAvatarsState.avatarUploadSuccess(String url) = _AvatarUploadSuccess;
  const factory UploadsAvatarsState.imagesUploadSuccess(List<String> urls) = _ImagesUploadSuccess;
  const factory UploadsAvatarsState.error(String message) = _Error;
}