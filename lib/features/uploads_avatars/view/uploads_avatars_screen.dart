import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/upload_avatars_localization.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class UploadsAvatarsScreen extends StatefulWidget {
  const UploadsAvatarsScreen({super.key, this.isSkip, this.currentPhotosCount});

  final bool? isSkip;
  final int? currentPhotosCount;

  @override
  State<UploadsAvatarsScreen> createState() => _UploadsAvatarsScreenState();
}

class _UploadsAvatarsScreenState extends State<UploadsAvatarsScreen> {
  final PageController _pageController = PageController();
  bool _avatarConfirmed = false;
  int _currentPage = 0;
  bool _isNavigating = false;
  late UploadsAvatarsCubit _cubit;

  final DeviceMediaLibrary _mediaLibrary = DeviceMediaLibrary();

  String _translateErrorKey(
    UploadAvatarsErrorKeys errorKey,
    BuildContext context,
  ) {
    switch (errorKey) {
      case UploadAvatarsErrorKeys.emptyFileData:
        return S.of(context).emptyFileData;
      case UploadAvatarsErrorKeys.theAvatarIsNotSelected:
        return S.of(context).theAvatarIsNotSelected;
      case UploadAvatarsErrorKeys.emptyAvatarData:
        return S.of(context).emptyAvatarData;
      case UploadAvatarsErrorKeys.avatarUploadError:
        return S.of(context).avatarUploadError;
      case UploadAvatarsErrorKeys.imageDeletionError:
        return S.of(context).imageDeletionError;
      case UploadAvatarsErrorKeys.errorDeletingAllImages:
        return S.of(context).errorDeletingAllImages;
      case UploadAvatarsErrorKeys.theLimitOf10ImagesHasBeenReached:
        return S.of(context).theLimitOf10ImagesHasBeenReached;
      case UploadAvatarsErrorKeys.thereAreNoImagesToDownload:
        return S.of(context).thereAreNoImagesToDownload;
      case UploadAvatarsErrorKeys.imageProcessingError:
        return S.of(context).imageProcessingError;
      case UploadAvatarsErrorKeys.imageUploadError:
        return S.of(context).imageUploadError;
      case UploadAvatarsErrorKeys.errorWhenClearingATemporaryFile:
        return S.of(context).errorWhenClearingATemporaryFile;
      case UploadAvatarsErrorKeys.couldntGetFileData:
        return S.of(context).couldntGetFileData;
      case UploadAvatarsErrorKeys.dragAndDropTheFilesHere:
        return S.of(context).dragAndDropTheFilesHere;
      case UploadAvatarsErrorKeys.orClickTheButton:
        return S.of(context).orClickTheButton;
      case UploadAvatarsErrorKeys.selectAFile:
        return S.of(context).selectAFile;
      case UploadAvatarsErrorKeys.selectFiles:
        return S.of(context).selectFiles;
      case UploadAvatarsErrorKeys.chooseAnAvatar:
        return S.of(context).choose_an_avatar;
      case UploadAvatarsErrorKeys.selectPhotos:
        return S.of(context).selectPhotos;
      case UploadAvatarsErrorKeys.uploadingAvatar:
        return S.of(context).uploadingAvatar;
    }
  }

  int get maxGallerySelectable {
    final existing = widget.currentPhotosCount;
    if (existing == null) return 10;
    final remaining = 10 - existing;
    return remaining > 0 ? remaining : 0;
  }

  bool get isWeb => kIsWeb;
  bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  bool get isWebOrDesktop => isWeb || isDesktop;

  Future<void> _showMediaPickerBottomSheet(
    BuildContext context,
    UploadsAvatarsCubit cubit, {
    bool isAvatar = false,
  }) async {
    final errorCouldntGetFileData = _translateErrorKey(
      UploadAvatarsErrorKeys.couldntGetFileData,
      context,
    );
    final errorUploadingAvatar = _translateErrorKey(
      UploadAvatarsErrorKeys.uploadingAvatar,
      context,
    );
    final localizations = S.current;

    if (isWebOrDesktop) {
      final pickerKey = GlobalKey<MediaPickerWidgetState>();

      final List<MapEntry<MediaItem, Uint8List?>>? filesWithBytes =
          await showDialog<List<MapEntry<MediaItem, Uint8List?>>>(
            context: context,
            builder:
                (context) => Dialog(
                  insetPadding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: min(500, MediaQuery.of(context).size.width * 0.9),
                    height: min(500, MediaQuery.of(context).size.height * 0.9),
                    child: MediaPickerWidget(
                      key: pickerKey,
                      initialSelection: const [],
                      maxSelection: isAvatar ? 1 : maxGallerySelectable,
                      allowMultiple: !isAvatar,
                      showVideos: false,
                      onConfirmed: (
                        List<MapEntry<MediaItem, Uint8List?>> selectedFiles,
                      ) {
                        Navigator.of(context).pop(selectedFiles);
                      },
                      enableDragDrop: true,
                      config: const MediaPickerConfig(),
                      allowedMimeTypes: const ['image/*'],
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                isAvatar
                                    ? localizations.choose_an_avatar
                                    : localizations.selectPhotos,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(localizations.dragAndDropTheFilesHere),
                              Text(localizations.orClickTheButton),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  await pickerKey.currentState?.pickFiles();
                                },
                                child: Text(
                                  isAvatar
                                      ? localizations.selectAFile
                                      : localizations.selectFiles,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          );

      if (filesWithBytes != null && filesWithBytes.isNotEmpty) {
        if (isAvatar) {
          final firstEntry = filesWithBytes.first;
          final firstItem = firstEntry.key;
          var bytes = firstEntry.value;

          if (bytes == null || bytes.isEmpty) {
            bytes = await _readFileBytes(firstItem.uri);
          }

          if (bytes != null && bytes.isNotEmpty) {
            cubit.selectAvatar(firstItem.uri, bytes);
          } else {
            if (context.mounted) {
              _showErrorSnackBar(context, errorCouldntGetFileData);
            }
          }
        } else {
          final filesWithBytesList = <MapEntry<String, Uint8List>>[];
          for (final entry in filesWithBytes) {
            var bytes = entry.value;

            if (bytes == null || bytes.isEmpty) {
              bytes = await _readFileBytes(entry.key.uri);
            }

            if (bytes != null && bytes.isNotEmpty) {
              filesWithBytesList.add(MapEntry(entry.key.uri, bytes));
            }
          }

          if (filesWithBytesList.isNotEmpty) {
            cubit.selectGalleryImages(filesWithBytesList);
          } else {
            if (context.mounted) {
              _showErrorSnackBar(context, errorCouldntGetFileData);
            }
          }
        }
      }
    } else {
      await MediaPickerBottomSheet.open(
        context: context,
        initialSelection: const [],
        maxSelection: isAvatar ? 1 : maxGallerySelectable,
        allowMultiple: !isAvatar,
        showVideos: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        showSelectionIndicators: true,
        config: const MediaPickerConfig(),
        mediaLibrary: _mediaLibrary,
        onConfirmed: (medias) {
          Navigator.pop(context);
        },
        onConfirmedWithBytes: (selectedItemsWithBytes) async {
          if (selectedItemsWithBytes.isEmpty) {
            return;
          }

          if (isAvatar) {
            final firstEntry = selectedItemsWithBytes.first;
            final firstItem = firstEntry.key;
            final bytes = firstEntry.value;

            if (bytes != null && bytes.isNotEmpty) {
              cubit.selectAvatar(firstItem.uri, bytes);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorUploadingAvatar),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }

              await cubit.uploadAvatar();
            } else {
              if (mounted) {
                _showErrorSnackBar(context, errorCouldntGetFileData);
              }
            }
          } else {
            final filesWithBytesList = <MapEntry<String, Uint8List>>[];
            for (final entry in selectedItemsWithBytes) {
              if (entry.value != null && entry.value!.isNotEmpty) {
                filesWithBytesList.add(MapEntry(entry.key.uri, entry.value!));
              }
            }

            if (filesWithBytesList.isNotEmpty) {
              cubit.selectGalleryImages(filesWithBytesList);
            } else {
              if (mounted) {
                _showErrorSnackBar(context, errorCouldntGetFileData);
              }
            }
          }
        },
      );
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<Uint8List?> _readFileBytes(String uri) async {
    try {
      if (uri.startsWith('data:')) {
        final base64Data = uri.split(',').last;
        return Uint8List.fromList(base64Decode(base64Data));
      }

      if (uri.startsWith('file://')) {
        final filePath = Uri.parse(uri).toFilePath(windows: Platform.isWindows);
        final file = File(filePath);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      }

      if (!uri.startsWith('http')) {
        final file = File(uri);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      }
    } catch (_) {}

    return null;
  }

  void _navigateToMainHome() {
    if (_isNavigating) return;
    _isNavigating = true;

    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) {
        _isNavigating = false;
        return;
      }

      try {
        context.router.pushAndPopUntil(
          const MainHomeRoute(),
          predicate: (route) => false,
        );
      } catch (e) {
        if (mounted) {
          context.pushRoute(MainHomeRoute());
        }
      } finally {
        _isNavigating = false;
      }
    });
  }

  void _handleSkipModeNavigation() {
    if (_isNavigating) return;
    _isNavigating = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _isNavigating = false;
        return;
      }

      try {
        context.read<SettingsCubit>().getCurrentUser();

        Future.delayed(const Duration(milliseconds: 200), () {
          if (!mounted) {
            _isNavigating = false;
            return;
          }

          try {
            Navigator.of(context, rootNavigator: true).pop();
          } catch (e) {
            if (mounted) {
              context.router.pop();
            }
          } finally {
            _isNavigating = false;
          }
        });
      } catch (e) {
        _isNavigating = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _cubit = context.read<UploadsAvatarsCubit>();

    if (widget.isSkip == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pageController.jumpToPage(1);
          setState(() => _currentPage = 1);
        }
      });
    }

    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage && mounted) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadsAvatarsCubit, UploadsAvatarsState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          avatarSelected: (uri, bytes) {},
          avatarLoading: () {},
          imagesLoading: () {},
          avatarUploadSuccess: (url) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _avatarConfirmed = true);
              }
            });
          },
          gallerySelected: (paths) {},
          imagesUploadSuccess: (urls) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }

              if (widget.isSkip == true) {
                _handleSkipModeNavigation();
              } else if (_cubit.isAvatarUploaded) {
                _navigateToMainHome();
              }
            });
          },
          error: (errorKey) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_translateErrorKey(errorKey, context)),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            });
          },
        );
      },
      child: BlocBuilder<UploadsAvatarsCubit, UploadsAvatarsState>(
        builder: (context, state) {
          final localizations = S.of(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(localizations.uploading_images),
              leading:
                  _currentPage == 1 && widget.isSkip != true
                      ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          if (mounted) {
                            setState(() => _currentPage = 0);
                          }
                        },
                      )
                      : null,
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AvatarPage(
                  state: state,
                  cubit: _cubit,
                  onPickAvatar:
                      () => _showMediaPickerBottomSheet(
                        context,
                        _cubit,
                        isAvatar: true,
                      ),
                  avatarConfirmed: _avatarConfirmed,
                  onAvatarConfirmedChange: (value) {
                    if (mounted) {
                      setState(() => _avatarConfirmed = value);
                    }
                  },
                ),
                GalleryPage(
                  state: state,
                  cubit: _cubit,
                  maxSelectable: maxGallerySelectable,
                  onPickImages:
                      () => _showMediaPickerBottomSheet(
                        context,
                        _cubit,
                        isAvatar: false,
                      ),
                  onNavigateToMainHome: _navigateToMainHome,
                ),
              ],
            ),
            bottomNavigationBar: SizedBox(
              height: 56,
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    if (widget.isSkip == true) {
                      _handleSkipModeNavigation();
                    } else {
                      _navigateToMainHome();
                    }
                  },
                  child: Text(localizations.skip),
                ),
              ),
            ),
            floatingActionButton: () {
              if (_currentPage == 0 && widget.isSkip == true) {
                return null;
              }

              if (_currentPage == 0) {
                if (_avatarConfirmed && _cubit.isAvatarUploaded) {
                  return FloatingActionButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      if (mounted) {
                        setState(() => _currentPage = 1);
                      }
                    },
                    child: const Icon(Icons.arrow_forward),
                  );
                }
                return null;
              }

              if (_currentPage == 1 && _cubit.areGalleryImagesSelected) {
                return FloatingActionButton(
                  onPressed: () {
                    _cubit.confirmAndUploadGallery();
                  },
                  child: const Icon(Icons.cloud_upload),
                );
              }

              return null;
            }(),
          );
        },
      ),
    );
  }
}
