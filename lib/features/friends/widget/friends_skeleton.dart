import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class FriendsSkeleton extends StatelessWidget {
  const FriendsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 16),
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 56,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SkeletonItem(
                            child: Row(
                              children: [
                                SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                    shape: BoxShape.circle,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 2,
                                          spacing: 6,
                                          lineStyle: SkeletonLineStyle(
                                            randomLength: true,
                                            height: 12,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            minLength:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                3,
                                            maxLength:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SkeletonLine(
                                        style: SkeletonLineStyle(
                                          height: 10,
                                          width: 80,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
