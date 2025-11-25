import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

class GalleryPage extends StatelessWidget {
  final UploadsAvatarsState state;
  final UploadsAvatarsCubit cubit;
  final VoidCallback onPickImages;
  final VoidCallback onNavigateToMainHome;

  const GalleryPage({
    super.key,
    required this.state,
    required this.cubit,
    required this.onPickImages,
    required this.onNavigateToMainHome,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = state.maybeWhen(
      imagesLoading: () => true,
      orElse: () => false,
    );
    final displayImages =
        cubit.selectedGalleryPaths.isNotEmpty
            ? cubit.selectedGalleryPaths
            : cubit.galleryImages;

    final areImagesUploaded = state.maybeWhen(
      imagesUploadSuccess: (urls) => true,
      orElse: () => false,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '${displayImages.length}/10 изображений',
            style: TextStyle(
              color: displayImages.length >= 10 ? Colors.red : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                displayImages.isEmpty
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
                      itemCount: displayImages.length,
                      itemBuilder: (_, index) {
                        final imagePath =
                            cubit.selectedGalleryPaths.isNotEmpty
                                ? cubit.selectedGalleryPaths[index]
                                : cubit.galleryImages[index];
                        final isLocalImage = cubit.selectedGalleryPaths
                            .contains(imagePath);
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    isLocalImage
                                        ? Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  const Icon(Icons.error),
                                        )
                                        : FutureBuilder<String>(
                                          future: cubit.getPresignedUrl(
                                            imagePath,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              return Image.network(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) =>
                                                        const Icon(Icons.error),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                              ),
                            ),
                            if (isLocalImage)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: GestureDetector(
                                  onTap: () => cubit.removeGalleryImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              if (isLoading) const LinearProgressIndicator(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    (isLoading || displayImages.length >= 10)
                        ? null
                        : onPickImages,
                child: Text(
                  displayImages.isNotEmpty
                      ? "Добавить еще изображения"
                      : "Добавить изображения",
                ),
              ),
              if (displayImages.length >= 10) ...[
                const SizedBox(height: 8),
                const Text(
                  'Достигнут лимит в 10 изображений',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              if (areImagesUploaded && cubit.selectedGalleryPaths.isEmpty) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onNavigateToMainHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Перейти на главный экран"),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
