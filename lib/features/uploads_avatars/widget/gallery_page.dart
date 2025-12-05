import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class GalleryPage extends StatefulWidget {
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
            '${displayUris.length}/${S.of(context).ten_images}',
            style: TextStyle(
              color: displayUris.length >= 10 ? Colors.red : Colors.grey,
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
                            style: TextStyle(color: Colors.grey),
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
                        final isLocalImage = widget.cubit.selectedGalleryUris
                            .contains(uri);

                        return _buildImageItem(uri, isLocalImage, index);
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
                    (isLoading || displayUris.length >= 10)
                        ? null
                        : widget.onPickImages,
                child: Text(
                  displayUris.isNotEmpty
                      ? S.of(context).add_more_images
                      : S.of(context).add_Images,
                ),
              ),
              if (displayUris.length >= 10) ...[
                const SizedBox(height: 8),
                Text(
                  S.of(context).the_limit_of_ten_images_has_been_reached,
                  style: TextStyle(color: Colors.red, fontSize: 12),
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

  Widget _buildImageItem(String uri, bool isLocalImage, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                isLocalImage ? _buildLocalImage(uri) : _buildNetworkImage(uri),
          ),
        ),
        if (isLocalImage)
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => widget.cubit.removeGalleryImage(index),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocalImage(String uri) {
    final bytes = widget.cubit.selectedGalleryBytes[uri];
    if (bytes != null) {
      return Image.memory(bytes, fit: BoxFit.cover);
    }
    return _buildErrorWidget();
  }

  Widget _buildNetworkImage(String imageUrl) {
    return FutureBuilder<String>(
      future: widget.cubit.getPresignedUrl(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return _buildErrorWidget();
        }

        final presignedUrl = snapshot.data!;
        return Image.network(
          presignedUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoadingWidget();
          },
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  Widget _buildErrorWidget() {
    return const Center(child: Icon(Icons.error, color: Colors.red));
  }
}
