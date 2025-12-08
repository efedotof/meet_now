import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'image_item.dart';

class GalleryPage extends StatefulWidget {
  final UploadsAvatarsState state;
  final UploadsAvatarsCubit cubit;
  final VoidCallback onPickImages;
  final VoidCallback onNavigateToMainHome;

  /// Сколько можно загрузить (из расчета оставшегося)
  final int maxSelectable;

  const GalleryPage({
    super.key,
    required this.state,
    required this.cubit,
    required this.onPickImages,
    required this.onNavigateToMainHome,
    required this.maxSelectable,
  });

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state.maybeWhen(
      imagesLoading: () => true,
      orElse: () => false,
    );

    final displayUris =
        widget.cubit.selectedGalleryUris.isNotEmpty
            ? widget.cubit.selectedGalleryUris
            : widget.cubit.galleryImages;

    final areImagesUploaded = widget.state.maybeWhen(
      imagesUploadSuccess: (urls) => true,
      orElse: () => false,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '${displayUris.length}/${widget.maxSelectable}',
            style: TextStyle(
              color:
                  displayUris.length >= widget.maxSelectable
                      ? Colors.red
                      : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                displayUris.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.photo_library,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).add_images_to_the_gallery,
                            style: const TextStyle(color: Colors.grey),
                          ),
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
                      itemCount: displayUris.length,
                      itemBuilder: (context, index) {
                        final uri = displayUris[index];
                        final isLocal = widget.cubit.selectedGalleryUris
                            .contains(uri);

                        return ImageItem(
                          cubit: widget.cubit,
                          uri: uri,
                          isLocalImage: isLocal,
                          index: index,
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
                    (isLoading || displayUris.length >= widget.maxSelectable)
                        ? null
                        : widget.onPickImages,
                child: Text(
                  displayUris.isNotEmpty
                      ? S.of(context).add_more_images
                      : S.of(context).add_Images,
                ),
              ),
              if (displayUris.length >= widget.maxSelectable) ...[
                const SizedBox(height: 8),
                Text(
                  S.of(context).the_limit_of_ten_images_has_been_reached,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              if (areImagesUploaded &&
                  widget.cubit.selectedGalleryUris.isEmpty) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: widget.onNavigateToMainHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(S.of(context).go_to_the_main_screen),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
