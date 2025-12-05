import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'user_network_image.dart';

class UserPhotosSection extends StatelessWidget {
  const UserPhotosSection({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).photo,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasImages) ...[
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('${images.length}'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              if (hasImages)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: UserNetworkImage(
                            imageKey: images[index],
                            width: 100,
                            height: 120,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        S.of(context).there_are_no_photos_yet,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S
                            .of(context)
                            .add_a_photo_so_that_other_users_can_recognize_you,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
