import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/route/app_route.dart';

class UploadsAvatarsView extends StatefulWidget {
  const UploadsAvatarsView({super.key});

  @override
  State<UploadsAvatarsView> createState() => _UploadsAvatarsViewState();
}

class _UploadsAvatarsViewState extends State<UploadsAvatarsView> {
  final PageController _pageController = PageController();
  late final UploadsAvatarsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<UploadsAvatarsCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cubit.isAvatarUploaded) {
        _pageController.jumpToPage(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadsAvatarsCubit, UploadsAvatarsState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (message) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
          avatarUploadSuccess: (url) {
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            _checkAndNavigate(context);
          },
          imagesUploadSuccess: (images) {
            _checkAndNavigate(context);
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          appBar: AppBar(title: const Text("Загрузка изображений")),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildAvatarPage(context, isLoading),
              _buildGalleryPage(context, isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarPage(BuildContext context, bool isLoading) {
    return FutureBuilder<String?>(
      future:
          _cubit.avatarUrl != null
              ? _cubit.getPresignedUrl(_cubit.avatarUrl!)
              : Future.value(null),
      builder: (context, snapshot) {
        final avatarPresignedUrl = snapshot.data;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage:
                        avatarPresignedUrl != null
                            ? NetworkImage(avatarPresignedUrl)
                            : null,
                    child:
                        avatarPresignedUrl == null
                            ? const Icon(Icons.person, size: 70)
                            : null,
                  ),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Добавьте аватар профиля",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null &&
                              result.files.single.path != null &&
                              context.mounted) {
                            context.read<UploadsAvatarsCubit>().uploadAvatar(
                              result.files.single.path!,
                            );
                          }
                        },
                child: const Text("Загрузить аватар"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGalleryPage(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child:
                _cubit.galleryImages.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text("Добавьте изображения в галерею"),
                        ],
                      ),
                    )
                    : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _cubit.galleryImages.length,
                      itemBuilder: (_, index) {
                        return FutureBuilder<String>(
                          future: _cubit.getPresignedUrl(
                            _cubit.galleryImages[index],
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(Icons.error),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      },
                    ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                isLoading
                    ? null
                    : () async {
                      final result = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.image,
                      );
                      if (result != null) {
                        final paths =
                            result.files
                                .where((file) => file.path != null)
                                .map((file) => file.path!)
                                .toList();
                        if (paths.isNotEmpty && context.mounted) {
                          context.read<UploadsAvatarsCubit>().uploadImages(
                            paths,
                          );
                        }
                      }
                    },
            child: const Text("Добавить изображения"),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text("Вернуться к аватару"),
          ),
        ],
      ),
    );
  }

  void _checkAndNavigate(BuildContext context) {
    if (_cubit.isAvatarUploaded && _cubit.areImagesUploaded) {
      context.router.replaceAll([const MainHomeRoute()]);
    }
  }
}
