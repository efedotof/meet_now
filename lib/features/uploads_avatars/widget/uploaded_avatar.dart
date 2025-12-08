import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

class UploadedAvatar extends StatelessWidget {
  const UploadedAvatar({
    super.key,
    required this.url,
    required this.cubit,
    this.presignedUrl,
    required this.onAvatarConfirmedChange,
  });
  final String url;
  final UploadsAvatarsCubit cubit;
  final String? presignedUrl;
  final ValueChanged<bool> onAvatarConfirmedChange;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage:
              presignedUrl != null ? NetworkImage(presignedUrl!) : null,
          child:
              presignedUrl == null
                  ? const Icon(Icons.person, size: 70, color: Colors.white)
                  : null,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              cubit.removeAvatar();
              onAvatarConfirmedChange(false);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
