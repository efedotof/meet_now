import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class ChatMessagesSkeleton extends StatelessWidget {
  const ChatMessagesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        final isMe = index % 3 == 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                    width: 40,
                    height: 40,
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4, left: 8),
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 12,
                            width: 80,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 16),
                        ),
                      ),
                      child: SkeletonItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                lines: index % 3 + 1, // 1-3 lines
                                spacing: 4,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 14,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  minLength: 50,
                                  maxLength: 200,
                                ),
                              ),
                            ),
                            if (index % 4 == 0) // Some messages with media
                              const SizedBox(height: 8),
                            if (index % 4 == 0)
                              const SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  width: 200,
                                  height: 120,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 10,
                          width: 40,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isMe) const SizedBox(width: 8),
              if (isMe)
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                    width: 40,
                    height: 40,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
