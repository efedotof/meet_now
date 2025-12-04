import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class SkeletonGiftItem extends StatelessWidget {
  const SkeletonGiftItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.grey.shade300,
      ),
      child: SkeletonTheme(
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
        child: Stack(
          children: [
            Positioned.fill(
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),

            Positioned(
              left: 3,
              top: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.grey.shade300,
                ),
                padding: const EdgeInsets.all(3),
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 15,
                    width: 80,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            Positioned(
              right: 3,
              top: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.grey.shade300,
                ),
                padding: const EdgeInsets.all(3),
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
