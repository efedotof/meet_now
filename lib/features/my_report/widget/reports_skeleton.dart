import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class ReportsSkeleton extends StatelessWidget {
  const ReportsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder:
          (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SkeletonItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                      lines: 2,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 16,
                        borderRadius: BorderRadius.circular(8),
                        minLength: MediaQuery.of(context).size.width / 3,
                        maxLength: MediaQuery.of(context).size.width / 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 14,
                      width: MediaQuery.of(context).size.width / 2,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 80,
                          height: 32,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 100,
                          height: 36,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
