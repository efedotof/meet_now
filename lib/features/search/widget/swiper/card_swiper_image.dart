import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class CardSwiperImage extends StatelessWidget {
  final String? imageUrl;
  final int totalImages;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;
  final VoidCallback onTap;

  const CardSwiperImage({
    super.key,
    required this.imageUrl,
    required this.totalImages,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (totalImages == 0) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.person, size: 80, color: Colors.white54),
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(
                S.of(context).retry,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (isLoading || imageUrl == null) {
      return SkeletonTheme(
        shimmerGradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade400,
            Colors.grey.shade300,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: const Alignment(-1.0, -0.5),
          end: const Alignment(1.0, 0.5),
        ),
        child: SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        key: ValueKey(imageUrl),

        placeholder: (_, _) => const SizedBox.shrink(),
        errorWidget: (_, _, _) => const SizedBox.shrink(),
      ),
    );
  }
}
