import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class GiftSkeleton extends StatelessWidget {
  const GiftSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SkeletonItem(
              child: Column(
                children: [
                  Row(
                    children: [
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 40,
                          height: 40,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 20,
                                borderRadius: BorderRadius.circular(8),
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 16,
                                borderRadius: BorderRadius.circular(6),
                                width: MediaQuery.of(context).size.width / 3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 14,
                                borderRadius: BorderRadius.circular(6),
                                width: MediaQuery.of(context).size.width / 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 80,
                          height: 40,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 16,
                      borderRadius: BorderRadius.circular(6),
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SkeletonItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 12,
                          width: 60,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16,
                          width: 30,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 12,
                          width: 60,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16,
                          width: 30,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 12,
                          width: 60,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16,
                          width: 30,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SkeletonItem(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: 6,
              itemBuilder:
                  (context, index) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SkeletonItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 16,
                              borderRadius: BorderRadius.circular(8),
                              width: MediaQuery.of(context).size.width / 3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 2,
                              spacing: 4,
                              lineStyle: SkeletonLineStyle(
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(6),
                                minLength:
                                    MediaQuery.of(context).size.width / 4,
                                maxLength:
                                    MediaQuery.of(context).size.width / 2,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 14,
                                  width: 40,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  width: 32,
                                  height: 32,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
