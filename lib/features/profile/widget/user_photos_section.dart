import 'package:flutter/material.dart';

import 'user_network_image.dart';

class UserPhotosSection extends StatelessWidget {
  const UserPhotosSection({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Фотографии',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: UserNetworkImage(
                  imageKey: images[index],
                  width: 100,
                  height: 120,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
