import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                    width: 120,
                    height: 120,
                  ),
                ),
                SizedBox(height: 16),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 24,
                    width: 200,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                SizedBox(height: 8),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 18,
                    width: 150,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                SizedBox(height: 8),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16,
                    width: 120,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 20,
                        height: 20,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 20,
                        height: 20,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 20,
                    width: 120,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder:
                        (context, index) => Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: const SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 100,
                              height: 120,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BuildStatSkeleton(),
                _BuildStatSkeleton(),
                _BuildStatSkeleton(),
                _BuildStatSkeleton(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 20,
                        height: 20,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 16,
                        width: 200,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 20,
                    width: 80,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                const SizedBox(height: 8),
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 3,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 14,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      minLength: 100,
                      maxLength: 300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonLine(
                style: SkeletonLineStyle(
                  height: 20,
                  width: 100,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  5,
                  (index) => const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: 80,
                      height: 32,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonLine(
                style: SkeletonLineStyle(
                  height: 20,
                  width: 120,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  3,
                  (index) => const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: 90,
                      height: 32,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 20,
                        width: 80,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    const SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 60,
                        height: 30,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder:
                        (context, index) => Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: const Column(
                            children: [
                              SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  shape: BoxShape.circle,
                                  width: 48,
                                  height: 48,
                                ),
                              ),
                              SizedBox(height: 4),
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 12,
                                  width: 40,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 20,
                    width: 80,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 20,
                            height: 20,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 14,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildStatSkeleton extends StatelessWidget {
  const _BuildStatSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: 28,
            height: 28,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 8),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 16,
            width: 20,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
        SizedBox(height: 4),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 12,
            width: 40,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ],
    );
  }
}
