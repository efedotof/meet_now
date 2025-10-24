import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

part 'uploads_avatars_state.dart';
part 'uploads_avatars_cubit.freezed.dart';

class UploadsAvatarsCubit extends Cubit<UploadsAvatarsState> {
  UploadsAvatarsCubit({required UploadImageInterface uploadImageInterface})
    : _uploadImageInterface = uploadImageInterface,
      super(const UploadsAvatarsState.initial());

  final UploadImageInterface _uploadImageInterface;
  String? _avatarUrl;
  List<String> _galleryImages = [];
  String? _selectedAvatarPath;
  List<String> _selectedGalleryPaths = [];

  String? get avatarUrl => _avatarUrl;
  List<String> get galleryImages => _galleryImages;
  String? get selectedAvatarPath => _selectedAvatarPath;
  List<String> get selectedGalleryPaths => _selectedGalleryPaths;

  void selectAvatar(String filePath) {
    _selectedAvatarPath = filePath;
    emit(UploadsAvatarsState.avatarSelected(filePath));
  }

  Future<void> confirmAndUploadAvatar() async {
    if (_selectedAvatarPath == null) {
      emit(const UploadsAvatarsState.error('Аватар не выбран'));
      return;
    }

    emit(const UploadsAvatarsState.avatarLoading());
    try {
      final url = await _uploadImageInterface.uploadAvatar(
        _selectedAvatarPath!,
      );
      _avatarUrl = url;
      _selectedAvatarPath = null;
      emit(UploadsAvatarsState.avatarUploadSuccess(url));
    } catch (e) {
      emit(UploadsAvatarsState.error('Ошибка загрузки аватара: $e'));
    }
  }

  void removeAvatar() {
    _selectedAvatarPath = null;
    _avatarUrl = null;
    emit(const UploadsAvatarsState.initial());
  }

  void selectGalleryImages(List<String> filesPath) {
    final availableSlots = 10 - _selectedGalleryPaths.length;
    if (availableSlots <= 0) {
      emit(const UploadsAvatarsState.error('Достигнут лимит в 10 изображений'));
      return;
    }

    final imagesToAdd = filesPath.take(availableSlots).toList();
    _selectedGalleryPaths.addAll(imagesToAdd);
    emit(UploadsAvatarsState.gallerySelected([..._selectedGalleryPaths]));
  }

  void removeGalleryImage(int index) {
    if (index >= 0 && index < _selectedGalleryPaths.length) {
      _selectedGalleryPaths.removeAt(index);
      if (_selectedGalleryPaths.isEmpty) {
        emit(const UploadsAvatarsState.initial());
      } else {
        emit(UploadsAvatarsState.gallerySelected([..._selectedGalleryPaths]));
      }
    }
  }

  Future<void> confirmAndUploadGallery() async {
    if (_selectedGalleryPaths.isEmpty) {
      emit(const UploadsAvatarsState.error('Нет изображений для загрузки'));
      return;
    }

    emit(const UploadsAvatarsState.imagesLoading());
    try {
      final urls = await _uploadImageInterface.uploadsImages(
        _selectedGalleryPaths,
      );
      _galleryImages = urls;
      _selectedGalleryPaths.clear();
      emit(UploadsAvatarsState.imagesUploadSuccess([..._galleryImages]));
    } catch (e) {
      emit(UploadsAvatarsState.error('Ошибка загрузки изображений: $e'));
    }
  }

  Future<String> getPresignedUrl(String fileUrl) async {
    try {
      final url = await _uploadImageInterface.getPresignedUrl(fileUrl);
      return url;
    } catch (e) {
      return "";
    }
  }

  bool get isAvatarUploaded => _avatarUrl != null;
  bool get areImagesUploaded => _galleryImages.isNotEmpty;
  bool get isAvatarSelected => _selectedAvatarPath != null;
  bool get areGalleryImagesSelected => _selectedGalleryPaths.isNotEmpty;
}
