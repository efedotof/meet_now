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

  String? _avatarUrl;
  List<String> _galleryImages = [];

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
            _avatarUrl = url;
            _checkAndNavigate(context);
          },
          imagesUploadSuccess: (images) {
            _galleryImages = images;
            _checkAndNavigate(context);
          },
        );
      },
      builder: (context, state) {
        bool isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        Widget avatarPage() {
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
                          _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                      child:
                          _avatarUrl == null
                              ? const Icon(Icons.person, size: 70)
                              : null,
                    ),
                    if (isLoading) const CircularProgressIndicator(),
                  ],
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
        }

        Widget galleryPage() {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child:
                      _galleryImages.isEmpty
                          ? const Center(child: Text("Нет изображений"))
                          : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: _galleryImages.length,
                            itemBuilder: (_, index) {
                              return Image.network(
                                _galleryImages[index],
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(Icons.error),
                              );
                            },
                          ),
                ),
                if (isLoading) const LinearProgressIndicator(),
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
                                context
                                    .read<UploadsAvatarsCubit>()
                                    .uploadImages(paths);
                              }
                            }
                          },
                  child: const Text("Добавить изображения"),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Загрузка изображений")),
          body: PageView(
            controller: _pageController,
            children: [avatarPage(), galleryPage()],
          ),
        );
      },
    );
  }

  void _checkAndNavigate(BuildContext context) {
    if (_avatarUrl != null && _galleryImages.isNotEmpty) {
      context.router.replaceAll([const MainHomeRoute()]);
    }
  }
}
