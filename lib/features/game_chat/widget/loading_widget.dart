import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 50,
              height: 50,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 16),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 16,
              width: 120,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
