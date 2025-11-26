import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          width: 50,
          height: 50,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
