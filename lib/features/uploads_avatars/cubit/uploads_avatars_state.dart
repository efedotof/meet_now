part of 'uploads_avatars_cubit.dart';

@freezed
class UploadsAvatarsState with _$UploadsAvatarsState {
  const factory UploadsAvatarsState.initial() = _Initial;
  const factory UploadsAvatarsState.avatarSelected(
    String uri,
    Uint8List bytes,
  ) = _AvatarSelected;
  const factory UploadsAvatarsState.avatarLoading() = _AvatarLoading;
  const factory UploadsAvatarsState.imagesLoading() = _ImagesLoading;
  const factory UploadsAvatarsState.avatarUploadSuccess(String url) =
      _AvatarUploadSuccess;
  const factory UploadsAvatarsState.gallerySelected(List<String> paths) =
      _GallerySelected;
  const factory UploadsAvatarsState.imagesUploadSuccess(List<String> urls) =
      _ImagesUploadSuccess;
  const factory UploadsAvatarsState.error(String message) = _Error;
}
