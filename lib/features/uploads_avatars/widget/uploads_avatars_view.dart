import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'avatar_page.dart';
import 'gallery_page.dart';

class UploadsAvatarsView extends StatefulWidget {
  const UploadsAvatarsView({super.key});

  @override
  State<UploadsAvatarsView> createState() => _UploadsAvatarsViewState();
}

class _UploadsAvatarsViewState extends State<UploadsAvatarsView> {
  final PageController _pageController = PageController();
  bool _avatarConfirmed = false;
  int _currentPage = 0;
  final DeviceMediaLibrary mediaLibrary = DeviceMediaLibrary();
  UploadsAvatarsCubit get _cubit => context.read<UploadsAvatarsCubit>();

  void _showMediaPickerBottomSheet({bool isAvatar = false}) async {
    final selectedItems = await showModalBottomSheet<List<MediaItem>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MediaPickerBottomSheet(
            initialSelection: const [],
            maxSelection: isAvatar ? 1 : 10,
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

  Widget? _buildFloatingActionButton(UploadsAvatarsState state) {
    if (_currentPage == 0) {
      if (_avatarConfirmed && _cubit.isAvatarUploaded) {
        return FloatingActionButton(
          onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {
              _currentPage = 1;
            });
          },
          child: const Icon(Icons.arrow_forward),
        );
      }
      return null;
    }

    if (_currentPage == 1 && _cubit.areGalleryImagesSelected) {
      return FloatingActionButton(
        onPressed: _cubit.confirmAndUploadGallery,
        child: const Icon(Icons.cloud_upload),
      );
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
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
          avatarUploadSuccess: (_) {
            setState(() => _avatarConfirmed = true);
          },
          imagesUploadSuccess: (_) {
            if (_cubit.isAvatarUploaded) {
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
                  _currentPage == 1
                      ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _currentPage = 0;
                          });
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
                  onPickImages:
                      () => _showMediaPickerBottomSheet(isAvatar: false),
                  onNavigateToMainHome: _navigateToMainHome,
                ),
              ],
            ),
            floatingActionButton: _buildFloatingActionButton(state),
          );
        },
      ),
    );
  }
}
