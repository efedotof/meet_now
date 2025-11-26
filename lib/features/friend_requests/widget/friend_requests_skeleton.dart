import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class FriendRequestsSkeleton extends StatelessWidget {
  const FriendRequestsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder:
          (context, index) => SkeletonItem(
            child: Row(
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                    width: 48,
                    height: 48,
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
                            height: 12,
                            borderRadius: BorderRadius.circular(6),
                            minLength: MediaQuery.of(context).size.width / 3,
                            maxLength: MediaQuery.of(context).size.width / 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 40,
                        height: 40,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 40,
                        height: 40,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
