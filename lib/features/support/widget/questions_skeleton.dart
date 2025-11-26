import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class QuestionsSkeleton extends StatelessWidget {
  const QuestionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder:
          (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SkeletonItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 20,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width / 3,
                              maxLength:
                                  MediaQuery.of(context).size.width / 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 70,
                          height: 32,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                      lines: 2,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 16,
                        borderRadius: BorderRadius.circular(6),
                        minLength: MediaQuery.of(context).size.width / 4,
                        maxLength: MediaQuery.of(context).size.width / 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Row(
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 16,
                              height: 16,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 14,
                              width: 30,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 14,
                          width: 80,
                          borderRadius: BorderRadius.circular(6),
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
