import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

import 'local_images.dart';
import 'network_image_widget.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({
    super.key,
    required this.cubit,
    required this.uri,
    required this.isLocalImage,
    required this.index,
  });
  final UploadsAvatarsCubit cubit;
  final String uri;
  final bool isLocalImage;
  final int index;

  @override
  Widget build(BuildContext context) {
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
                isLocalImage
                    ? LocalImages(urlss: uri, cubit: cubit)
                    : NetworkImageWidget(imageUrl: uri, cubit: cubit),
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
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );
  }
}
