import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

class SelectedAvatar extends StatelessWidget {
  const SelectedAvatar({super.key, required this.bytes, required this.cubit});
  final Uint8List bytes;
  final UploadsAvatarsCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(radius: 70, backgroundImage: MemoryImage(bytes)),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: cubit.removeAvatar,
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
