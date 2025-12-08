import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

import 'error_widgets.dart';

class LocalImages extends StatelessWidget {
  const LocalImages({super.key, required this.urlss, required this.cubit});
  final String urlss;
  final UploadsAvatarsCubit cubit;
  @override
  Widget build(BuildContext context) {
    final bytes = cubit.selectedGalleryBytes[urlss];
    if (bytes != null) {
      return Image.memory(bytes, fit: BoxFit.cover);
    }
    return ErrorWidgets();
  }
}
