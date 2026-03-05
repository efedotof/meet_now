import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class SkeletonGiftItem extends StatelessWidget {
  final bool isMobile;

  const SkeletonGiftItem({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 13 : 16),
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
                  borderRadius: BorderRadius.circular(isMobile ? 13 : 16),
                ),
              ),
            ),

            Positioned(
              left: 3,
              top: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 13 : 16),
                  color: Colors.grey.shade300,
                ),
                padding: const EdgeInsets.all(3),
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                    height: isMobile ? 15 : 18,
                    width: isMobile ? 80 : 100,
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
                  borderRadius: BorderRadius.circular(isMobile ? 13 : 16),
                  color: Colors.grey.shade300,
                ),
                padding: const EdgeInsets.all(3),
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                    width: isMobile ? 24 : 28,
                    height: isMobile ? 24 : 28,
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
