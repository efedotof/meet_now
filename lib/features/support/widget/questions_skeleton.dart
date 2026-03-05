import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class QuestionsSkeleton extends StatelessWidget {
  final bool isMobile;
  const QuestionsSkeleton({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 20,
        left: isMobile ? 0 : 20,
        right: isMobile ? 0 : 20,
        top: isMobile ? 8 : 16,
      ),
      child: Column(
        children: [
          ...List.generate(
            6,
            (index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 0,
                vertical: isMobile ? 8 : 12,
              ),
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
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
                                height: isMobile ? 20 : 24,
                                borderRadius: BorderRadius.circular(8),
                                minLength:
                                    isMobile
                                        ? MediaQuery.of(context).size.width / 3
                                        : 200,
                                maxLength:
                                    isMobile
                                        ? MediaQuery.of(context).size.width /
                                            1.5
                                        : 400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: isMobile ? 70 : 90,
                            height: isMobile ? 32 : 40,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(
                              isMobile ? 16 : 20,
                            ),
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
                          height: isMobile ? 16 : 18,
                          borderRadius: BorderRadius.circular(6),
                          minLength:
                              isMobile
                                  ? MediaQuery.of(context).size.width / 4
                                  : 150,
                          maxLength:
                              isMobile
                                  ? MediaQuery.of(context).size.width / 1.2
                                  : 350,
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
                                width: isMobile ? 16 : 18,
                                height: isMobile ? 16 : 18,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: isMobile ? 14 : 16,
                                width: isMobile ? 30 : 40,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            height: isMobile ? 14 : 16,
                            width: isMobile ? 80 : 120,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
