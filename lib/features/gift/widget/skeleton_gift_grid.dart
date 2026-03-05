import 'package:flutter/material.dart';
import 'package:meet_now_app/features/gift/widget/skeleton_gift_item.dart';

class SkeletonGiftGrid extends StatelessWidget {
  final bool isMobile;

  const SkeletonGiftGrid({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: isMobile ? 16 : 20,
        mainAxisSpacing: isMobile ? 16 : 20,
        childAspectRatio: isMobile ? 0.8 : 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return SkeletonGiftItem(isMobile: isMobile);
      },
    );
  }
}
