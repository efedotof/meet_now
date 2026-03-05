import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class ReportsSkeleton extends StatelessWidget {
  final bool isMobile;
  const ReportsSkeleton({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: isMobile ? MediaQuery.of(context).size.height * 0.1 : 20,
        bottom: 20,
        left: isMobile ? 12 : 20,
        right: isMobile ? 12 : 20,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: isMobile ? 0 : 20,
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          ),
          child: SkeletonItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 2,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: isMobile ? 16 : 18,
                      borderRadius: BorderRadius.circular(8),
                      minLength:
                          isMobile
                              ? MediaQuery.of(context).size.width / 3
                              : 200,
                      maxLength:
                          isMobile
                              ? MediaQuery.of(context).size.width / 1.5
                              : 400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: isMobile ? 14 : 16,
                    width:
                        isMobile ? MediaQuery.of(context).size.width / 2 : 300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: isMobile ? 80 : 100,
                        height: isMobile ? 32 : 40,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                      ),
                    ),
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: isMobile ? 100 : 120,
                        height: isMobile ? 36 : 44,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(isMobile ? 18 : 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
