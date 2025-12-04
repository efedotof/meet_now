import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class SkeletonPoints extends StatelessWidget {
  const SkeletonPoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey.shade300, // Серый фон
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [Colors.grey, Colors.grey, Colors.grey],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment(-1.0, -0.5),
          end: Alignment(1.0, 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
                width: 20,
                height: 20,
                padding: const EdgeInsets.only(right: 8),
              ),
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 15,
                width: 60,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
