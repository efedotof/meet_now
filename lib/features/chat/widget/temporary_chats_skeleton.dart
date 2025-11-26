import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class TemporaryChatsSkeleton extends StatelessWidget {
  const TemporaryChatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder:
          (context, index) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SkeletonItem(
              child: Row(
                children: [
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: 56,
                      height: 56,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 16,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width / 4,
                              maxLength: MediaQuery.of(context).size.width / 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 14,
                              borderRadius: BorderRadius.circular(6),
                              minLength: MediaQuery.of(context).size.width / 3,
                              maxLength:
                                  MediaQuery.of(context).size.width / 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 12,
                      width: 40,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
