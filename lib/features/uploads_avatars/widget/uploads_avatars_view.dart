import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/route/app_route.dart';
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

  UploadsAvatarsCubit get _cubit => context.read<UploadsAvatarsCubit>();

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _cubit.selectAvatar(result.files.single.path!);
    }
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      final paths = result.paths.whereType<String>().toList();
      if (paths.isNotEmpty) {
        _cubit.selectGalleryImages(paths);
      }
    }
  }

  void _navigateToMainHome() {
    context.router.replaceAll([const MainHomeRoute()]);
  }

  Widget? _buildFloatingActionButton(UploadsAvatarsState state) {
    final currentPage = _pageController.page?.round() ?? 0;

    if (currentPage == 0) {
      if (_avatarConfirmed && _cubit.isAvatarUploaded) {
        return FloatingActionButton(
          onPressed: () => _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          child: const Icon(Icons.arrow_forward),
        );
      }
      return null;
    }

    if (currentPage == 1 && _cubit.areGalleryImagesSelected) {
      return FloatingActionButton(
        onPressed: _cubit.confirmAndUploadGallery,
        child: const Icon(Icons.cloud_upload),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadsAvatarsCubit, UploadsAvatarsState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
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
            appBar: AppBar(title: const Text("Загрузка изображений")),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AvatarPage(
                  state: state,
                  cubit: _cubit,
                  onPickAvatar: _pickAvatar,
                  avatarConfirmed: _avatarConfirmed,
                  onAvatarConfirmedChange: (value) =>
                      setState(() => _avatarConfirmed = value),
                ),
                GalleryPage(
                  state: state,
                  cubit: _cubit,
                  onPickImages: _pickImages,
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