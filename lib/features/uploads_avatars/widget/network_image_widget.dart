import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

import 'error_widgets.dart';
import 'loading_widget.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    required this.cubit,
  });
  final String imageUrl;
  final UploadsAvatarsCubit cubit;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: cubit.getPresignedUrl(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return ErrorWidgets();
        }

        final presignedUrl = snapshot.data!;
        return Image.network(
          presignedUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return LoadingWidget();
          },
          errorBuilder: (context, error, stackTrace) => ErrorWidgets(),
        );
      },
    );
  }
}
