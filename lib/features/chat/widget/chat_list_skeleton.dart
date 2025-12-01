import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class ChatListSkeleton extends StatelessWidget {
  const ChatListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SkeletonItem(
              child: Row(
                children: [
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: 40,
                      height: 40,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 16,
                            borderRadius: BorderRadius.circular(8),
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                      width: 16,
                      height: 16,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 20,
              borderRadius: BorderRadius.circular(8),
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
        ),

        ...List.generate(
          6,
          (index) => Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
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
                                minLength:
                                    MediaQuery.of(context).size.width / 4,
                                maxLength:
                                    MediaQuery.of(context).size.width / 2,
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
                                minLength:
                                    MediaQuery.of(context).size.width / 3,
                                maxLength:
                                    MediaQuery.of(context).size.width / 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 12,
                            width: 40,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 8,
                            height: 8,
                            shape: BoxShape.circle,
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
    );
  }
}
