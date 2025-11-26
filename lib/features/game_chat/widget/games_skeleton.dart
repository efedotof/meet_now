import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class GamesSkeleton extends StatelessWidget {
  const GamesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: 6,
        itemBuilder:
            (context, index) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SkeletonItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 16,
                                    borderRadius: BorderRadius.circular(8),
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                ),
                                const SizedBox(height: 6),
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
                              ],
                            ),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 20,
                                width: 60,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
