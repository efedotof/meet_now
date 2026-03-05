import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/upload_avatars_localization.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'uploads_avatars_state.dart';
part 'uploads_avatars_cubit.freezed.dart';

class UploadsAvatarsCubit extends Cubit<UploadsAvatarsState> {
  UploadsAvatarsCubit({required UploadImageInterface uploadImageInterface})
    : _uploadImageInterface = uploadImageInterface,
      super(const UploadsAvatarsState.initial());

  final UploadImageInterface _uploadImageInterface;

  String? _avatarUrl;
  final List<String> _galleryImages = [];
  String? _selectedAvatarUri;
  Uint8List? _selectedAvatarBytes;
  final List<String> _selectedGalleryUris = [];
  final Map<String, Uint8List> _selectedGalleryBytes = {};
  final Map<String, String> _tempFilePaths = {};
  final Map<String, String> _presignedUrlCache = {};

  String? get avatarUrl => _avatarUrl;
  List<String> get galleryImages => _galleryImages;
  String? get selectedAvatarUri => _selectedAvatarUri;
  Uint8List? get selectedAvatarBytes => _selectedAvatarBytes;
  List<String> get selectedGalleryUris =>
      List.unmodifiable(_selectedGalleryUris);
  Map<String, Uint8List> get selectedGalleryBytes =>
      Map.unmodifiable(_selectedGalleryBytes);

  void selectAvatar(String uri, Uint8List bytes) {
    if (bytes.isEmpty) {
      emit(UploadsAvatarsState.error(UploadAvatarsErrorKeys.emptyFileData));
      return;
    }

    _selectedAvatarUri = uri;
    _selectedAvatarBytes = bytes;
    emit(UploadsAvatarsState.avatarSelected(uri, bytes));
  }

  void confirmAvatar() {
    if (_selectedAvatarUri == null || _selectedAvatarBytes == null) {
      emit(
        UploadsAvatarsState.error(
          UploadAvatarsErrorKeys.theAvatarIsNotSelected,
        ),
      );
      return;
    }
    emit(
      UploadsAvatarsState.avatarSelected(
        _selectedAvatarUri!,
        _selectedAvatarBytes!,
      ),
    );
  }

  Future<void> uploadAvatar() async {
    if (_selectedAvatarUri == null || _selectedAvatarBytes == null) {
      emit(
        UploadsAvatarsState.error(
          UploadAvatarsErrorKeys.theAvatarIsNotSelected,
        ),
      );
      return;
    }

    if (_selectedAvatarBytes!.isEmpty) {
      emit(UploadsAvatarsState.error(UploadAvatarsErrorKeys.emptyAvatarData));
      return;
    }

    emit(const UploadsAvatarsState.avatarLoading());

    try {
      String url;

      if (kIsWeb) {
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

        url = await _uploadImageInterface.uploadAvatarBytes(
          _selectedAvatarBytes!,
          fileName,
        );
      } else {
        final tempFile = await _createTempFileFromBytes(_selectedAvatarBytes!);

        url = await _uploadImageInterface.uploadAvatar(tempFile.path);

        await tempFile.delete();
      }

      _avatarUrl = url;
      _selectedAvatarUri = null;
      _selectedAvatarBytes = null;

      emit(UploadsAvatarsState.avatarUploadSuccess(url));
    } catch (e) {
      emit(UploadsAvatarsState.error(UploadAvatarsErrorKeys.avatarUploadError));
    }
  }

  Future<File> _createTempFileFromBytes(Uint8List bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/avatar_$timestamp.jpg');
      await tempFile.writeAsBytes(bytes);
      return tempFile;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserImage({required String imageUrl}) async {
    try {
      await _uploadImageInterface.deleatImage(imageUrl: imageUrl);
    } catch (e) {
      emit(
        UploadsAvatarsState.error(UploadAvatarsErrorKeys.imageDeletionError),
      );
    }
  }

  Future<void> deleteAllUserImage() async {
    try {
      await _uploadImageInterface.deleatAllImage();
    } catch (e) {
      emit(
        UploadsAvatarsState.error(
          UploadAvatarsErrorKeys.errorDeletingAllImages,
        ),
      );
    }
  }

  void removeAvatar() {
    if (_avatarUrl != null) {
      _presignedUrlCache.remove(_avatarUrl);
    }
    _selectedAvatarUri = null;
    _selectedAvatarBytes = null;
    _avatarUrl = null;
    emit(const UploadsAvatarsState.initial());
  }

  void selectGalleryImages(List<MapEntry<String, Uint8List>> mediaList) {
    final availableSlots = 10 - _selectedGalleryUris.length;
    if (availableSlots <= 0) {
      emit(
        UploadsAvatarsState.error(
          UploadAvatarsErrorKeys.theLimitOf10ImagesHasBeenReached,
        ),
      );
      return;
    }

    final itemsToAdd = mediaList.take(availableSlots).toList();
    for (final item in itemsToAdd) {
      if (item.value.isNotEmpty) {
        _selectedGalleryUris.add(item.key);
        _selectedGalleryBytes[item.key] = item.value;
      }
    }

    if (_selectedGalleryUris.isNotEmpty) {
      emit(UploadsAvatarsState.gallerySelected([..._selectedGalleryUris]));
    } else {
      emit(
        UploadsAvatarsState.error(
          UploadAvatarsErrorKeys.thereAreNoImagesToDownload,
        ),
      );
    }
  }

  void removeGalleryImage(int index) {
    if (index >= 0 && index < _selectedGalleryUris.length) {
      final uri = _selectedGalleryUris[index];
      _selectedGalleryUris.removeAt(index);
      _selectedGalleryBytes.remove(uri);
      if (_tempFilePaths.containsKey(uri) && !kIsWeb) {
        try {
          final tempFile = File(_tempFilePaths[uri]!);
          if (tempFile.existsSync()) {
            tempFile.deleteSync();
          }
          _tempFilePaths.remove(uri);
        } catch (_) {}
      }

      if (_selectedGalleryUris.isEmpty) {
        emit(const UploadsAvatarsState.initial());
      } else {
        emit(UploadsAvatarsState.gallerySelected([..._selectedGalleryUris]));
      }
    }
  }

  void confirmGallerySelection() {
    if (_selectedGalleryUris.isEmpty) {
      emit(
        UploadsAvatarsState.error(
          UploadAvatarsErrorKeys.thereAreNoImagesToDownload,
        ),
      );
      return;
    }
    emit(UploadsAvatarsState.gallerySelected([..._selectedGalleryUris]));
  }

  Future<void> uploadGallery() async {
    if (_selectedGalleryUris.isEmpty) {
      emit(
        UploadsAvatarsState.error(
          UploadAvatarsErrorKeys.thereAreNoImagesToDownload,
        ),
      );
      return;
    }

    emit(const UploadsAvatarsState.imagesLoading());

    try {
      if (kIsWeb) {
        final files = <MapEntry<Uint8List, String>>[];

        for (final uri in _selectedGalleryUris) {
          final bytes = _selectedGalleryBytes[uri];
          if (bytes != null && bytes.isNotEmpty) {
            final timestamp = DateTime.now().microsecondsSinceEpoch;
            files.add(
              MapEntry(bytes, 'gallery_${timestamp}_${uri.hashCode}.jpg'),
            );
          }
        }

        if (files.isEmpty) {
          emit(
            UploadsAvatarsState.error(
              UploadAvatarsErrorKeys.imageProcessingError,
            ),
          );
          return;
        }

        final urls = await _uploadImageInterface.uploadImagesBytes(files);
        _galleryImages.addAll(urls);
      } else {
        final tempFiles = <File>[];
        final paths = <String>[];

        for (final uri in _selectedGalleryUris) {
          final bytes = _selectedGalleryBytes[uri];
          if (bytes != null && bytes.isNotEmpty) {
            final tempFile = await _createTempFileForGallery(uri, bytes);
            tempFiles.add(tempFile);
            paths.add(tempFile.path);
          }
        }

        if (paths.isEmpty) {
          emit(
            UploadsAvatarsState.error(
              UploadAvatarsErrorKeys.imageProcessingError,
            ),
          );
          return;
        }

        final urls = await _uploadImageInterface.uploadsImages(paths);
        _galleryImages.addAll(urls);

        for (final file in tempFiles) {
          try {
            await file.delete();
          } catch (_) {}
        }

        for (final uri in _selectedGalleryUris) {
          _tempFilePaths.remove(uri);
        }
      }

      _selectedGalleryUris.clear();
      _selectedGalleryBytes.clear();

      emit(UploadsAvatarsState.imagesUploadSuccess([..._galleryImages]));
    } catch (e) {
      emit(UploadsAvatarsState.error(UploadAvatarsErrorKeys.imageUploadError));
    }
  }

  Future<void> confirmAndUploadGallery() async {
    await uploadGallery();
  }

  Future<File> _createTempFileForGallery(String uri, Uint8List bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomId = DateTime.now().microsecondsSinceEpoch;
      final tempFile = File(
        '${tempDir.path}/gallery_${timestamp}_$randomId.jpg',
      );
      _tempFilePaths[uri] = tempFile.path;
      await tempFile.writeAsBytes(bytes);
      return tempFile;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getPresignedUrl(String fileUrl) async {
    if (_presignedUrlCache.containsKey(fileUrl)) {
      return _presignedUrlCache[fileUrl]!;
    }

    try {
      final url = await _uploadImageInterface.getPresignedUrl(fileUrl);
      if (url.isNotEmpty) {
        _presignedUrlCache[fileUrl] = url;
      }
      return url;
    } catch (e) {
      return "";
    }
  }

  bool get isAvatarUploaded => _avatarUrl != null;
  bool get areImagesUploaded => _galleryImages.isNotEmpty;
  bool get isAvatarSelected => _selectedAvatarUri != null;
  bool get areGalleryImagesSelected => _selectedGalleryUris.isNotEmpty;
  bool get isAvatarConfirmed =>
      _avatarUrl != null ||
      (state is _AvatarSelected && _selectedAvatarUri != null);

  @override
  Future<void> close() {
    if (!kIsWeb) {
      _cleanupTempFiles();
    }
    return super.close();
  }

  void _cleanupTempFiles() {
    for (final path in _tempFilePaths.values) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e) {
        emit(
          UploadsAvatarsState.error(
            UploadAvatarsErrorKeys.errorWhenClearingATemporaryFile,
          ),
        );
      }
    }
    _tempFilePaths.clear();
  }
}
