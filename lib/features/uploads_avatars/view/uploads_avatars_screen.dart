import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

@RoutePage()
class UploadsAvatarsScreen extends StatefulWidget {
  const UploadsAvatarsScreen({super.key, this.isSkip, this.currentPhotosCount});

  /// Если true - сразу перейти к галерее
  final bool? isSkip;

  /// Сколько фото уже загружено пользователем (может быть null)
  final int? currentPhotosCount;

  @override
  State<UploadsAvatarsScreen> createState() => _UploadsAvatarsScreenState();
}

class _UploadsAvatarsScreenState extends State<UploadsAvatarsScreen> {
  final PageController _pageController = PageController();
  bool _avatarConfirmed = false;
  int _currentPage = 0;
  final DeviceMediaLibrary mediaLibrary = DeviceMediaLibrary();
  UploadsAvatarsCubit get _cubit => context.read<UploadsAvatarsCubit>();

  int get maxGallerySelectable {
    final existing = widget.currentPhotosCount;
    if (existing == null) return 10;
    final remaining = 10 - existing;
    return remaining > 0 ? remaining : 0;
  }

  void _showMediaPickerBottomSheet({bool isAvatar = false}) async {
    final selectedItems = await showModalBottomSheet<List<MediaItem>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MediaPickerBottomSheet(
            initialSelection: const [],
            maxSelection: isAvatar ? 1 : maxGallerySelectable,
            allowMultiple: !isAvatar,
            showVideos: false,
            initialChildSize: 0.7,
            minChildSize: 0.4,
            showSelectionIndicators: true,
            maxChildSize: 0.9,
          ),
    );

    if (selectedItems != null && selectedItems.isNotEmpty) {
      final mediaList = <MapEntry<String, Uint8List>>[];
      for (final item in selectedItems) {
        try {
          final bytes = await mediaLibrary.getFileBytes(item.uri);
          if (bytes != null) {
            mediaList.add(MapEntry(item.uri, bytes));
          }
        } catch (e) {
          debugPrint('Ошибка загрузки изображения: $e');
        }
      }

      if (mediaList.isNotEmpty) {
        if (isAvatar) {
          _cubit.selectAvatar(mediaList.first.key, mediaList.first.value);
        } else {
          _cubit.selectGalleryImages(mediaList);
        }
      }
    }
  }

  void _navigateToMainHome() {
    context.router.replaceAll([const MainHomeRoute()]);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isSkip == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(1);
        setState(() => _currentPage = 1);
      });
    }

    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
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
        state.whenOrNull(
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          },
          avatarUploadSuccess: (_) => setState(() => _avatarConfirmed = true),
          imagesUploadSuccess: (_) {
            if (widget.isSkip == true) {
              context.read<SettingsCubit>().getCurrentUser();
              context.maybePop();
            } else if (_cubit.isAvatarUploaded) {
              _navigateToMainHome();
            }
          },
        );
      },
      child: BlocBuilder<UploadsAvatarsCubit, UploadsAvatarsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).uploading_images),
              leading:
                  _currentPage == 1 && widget.isSkip != true
                      ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() => _currentPage = 0);
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
                      () => _showMediaPickerBottomSheet(isAvatar: true),
                  avatarConfirmed: _avatarConfirmed,
                  onAvatarConfirmedChange:
                      (value) => setState(() => _avatarConfirmed = value),
                ),
                GalleryPage(
                  state: state,
                  cubit: _cubit,
                  maxSelectable: maxGallerySelectable,
                  onPickImages:
                      () => _showMediaPickerBottomSheet(isAvatar: false),
                  onNavigateToMainHome: _navigateToMainHome,
                ),
              ],
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
                      setState(() => _currentPage = 1);
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

                    context.read<SettingsCubit>().getCurrentUser();
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
