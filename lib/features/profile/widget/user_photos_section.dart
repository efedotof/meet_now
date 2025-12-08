import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/uploads_avatars.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'empty_state.dart';
import 'user_network_image.dart';

class UserPhotosSection extends StatelessWidget {
  const UserPhotosSection({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty;
    final isDark = Theme.brightnessOf(context) == Brightness.dark;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).photo,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (hasImages) ...[
                        const SizedBox(width: 8),
                        Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          label: Text('${images.length}'),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ],
                  ),

                  RawMaterialButton(
                    fillColor: isDark ? Colors.white : Colors.black,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.black54,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.92,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(22),
                              ),
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: UploadsAvatarsScreen(
                                  isSkip: true,
                                  currentPhotosCount: images.length,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    elevation: 2.0,
                    shape: const CircleBorder(),
                    constraints: const BoxConstraints(minWidth: 0.0),
                    child: Icon(
                      Icons.add,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (!hasImages)
                const EmptyState()
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    double space = 12;
                    double maxWidth = constraints.maxWidth;
                    final count = maxWidth <= 380 ? 2 : 3;
                    final itemWidth = (maxWidth - space * (count - 1)) / count;

                    return Wrap(
                      spacing: space,
                      runSpacing: space,
                      children: List.generate(
                        images.length,
                        (index) => SizedBox(
                          width: itemWidth,
                          height: itemWidth * 1.05,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: UserNetworkImage(imageKey: images[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
