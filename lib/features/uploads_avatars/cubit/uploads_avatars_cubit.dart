import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/repository/upload_image/upload_image_interface.dart';

part 'uploads_avatars_state.dart';
part 'uploads_avatars_cubit.freezed.dart';

class UploadsAvatarsCubit extends Cubit<UploadsAvatarsState> {
  UploadsAvatarsCubit({required UploadImageInterface uploadImageInterface})
    : _uploadImageInterface = uploadImageInterface,
      super(const UploadsAvatarsState.initial());

  final UploadImageInterface _uploadImageInterface;

  Future<void> uploadAvatar(String filePath) async {
    emit(const UploadsAvatarsState.loading());
    try {
      final url = await _uploadImageInterface.uploadAvatar(filePath);
      emit(UploadsAvatarsState.avatarUploadSuccess(url));
    } catch (e) {
      emit(UploadsAvatarsState.error('Ошибка загрузки аватара: $e'));
    }
  }

  Future<void> uploadImages(List<String> filesPath) async {
    emit(const UploadsAvatarsState.loading());
    try {
      final urls = await _uploadImageInterface.uploadsImages(filesPath);
      emit(UploadsAvatarsState.imagesUploadSuccess(urls));
    } catch (e) {
      emit(UploadsAvatarsState.error('Ошибка загрузки изображений: $e'));
    }
  }
}