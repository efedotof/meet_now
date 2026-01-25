import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/uploads_avatars.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'empty_state.dart';
import 'user_network_image.dart';

class UserPhotosSection extends StatefulWidget {
  const UserPhotosSection({super.key, required this.images});
  final List<String> images;

  @override
  State<UserPhotosSection> createState() => _UserPhotosSectionState();
}

class _UserPhotosSectionState extends State<UserPhotosSection> {
  final Set<String> _cachedImages = {};
  final _defaultCacheManager = DefaultCacheManager();

  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  @override
  void didUpdateWidget(UserPhotosSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.images != oldWidget.images) {
      _precacheImages();
    }
  }

  Future<void> _precacheImages() async {
    if (widget.images.isEmpty) return;

    final cubit = context.read<UploadsAvatarsCubit>();
    final List<Future<void>> futures = [];

    for (final imageKey in widget.images) {
      if (_cachedImages.contains(imageKey)) continue;

      futures.add(() async {
        try {
          final presignedUrl = await cubit.getPresignedUrl(imageKey);
          if (presignedUrl.isNotEmpty) {
            await _defaultCacheManager.downloadFile(
              presignedUrl,
              key: imageKey,
              authHeaders: {},
            );
            _cachedImages.add(imageKey);
          }
        } catch (e) {
          //
        }
      }());
    }

    unawaited(Future.wait(futures));
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;
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
                          label: Text('${widget.images.length}'),
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
                                  currentPhotosCount: widget.images.length,
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
                        widget.images.length,
                        (index) => SizedBox(
                          width: itemWidth,
                          height: itemWidth * 1.05,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: UserNetworkImage(
                              imageKey: widget.images[index],
                              allImageKeys: widget.images,
                              index: index,
                            ),
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
