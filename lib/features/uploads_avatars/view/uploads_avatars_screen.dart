import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart'
    show MediaPickerBottomSheet, MediaPickerConfig, DeviceMediaLibrary;

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

  final DeviceMediaLibrary _mediaLibrary = DeviceMediaLibrary();

  UploadsAvatarsCubit get _cubit => context.read<UploadsAvatarsCubit>();

  int get maxGallerySelectable {
    final existing = widget.currentPhotosCount;
    if (existing == null) return 10;
    final remaining = 10 - existing;
    return remaining > 0 ? remaining : 0;
  }

  Future<void> _showMediaPickerBottomSheet({bool isAvatar = false}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return MediaPickerBottomSheet(
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

          onConfirmed: (filesWithBytes) {
            if (filesWithBytes.isEmpty) return;

            if (isAvatar) {
              final first = filesWithBytes.first;
              _cubit.selectAvatar(first.key, first.value);
            } else {
              _cubit.selectGalleryImages(filesWithBytes);
            }

            // Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  void _navigateToMainHome() {
    if (_isNavigating) return;
    _isNavigating = true;

    // Используем небольшую задержку перед навигацией
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
          // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (_) => const MainHomeRoute()),
          //   (route) => false,
          // );
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
              if (!mounted) return;

              if (widget.isSkip == true) {
                _handleSkipModeNavigation();
              } else if (_cubit.isAvatarUploaded) {
                _navigateToMainHome();
              }
            });
          },
          error: (message) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
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
                      () => _showMediaPickerBottomSheet(isAvatar: true),
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
