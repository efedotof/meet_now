import 'package:flutter/material.dart';
import 'package:meet_now_app/features/gift/widget/skeleton_gift_item.dart';

class SkeletonGiftGrid extends StatelessWidget {
  const SkeletonGiftGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const SkeletonGiftItem();
      },
    );
  }
}
