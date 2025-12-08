import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.state});
  final UploadsAvatarsState state;
  @override
  Widget build(BuildContext context) {
    return state.when(
      initial:
          () => Text(
            S.of(context).add_a_profile_avatar,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      avatarSelected:
          (uri, bytes) => Text(
            S.of(context).the_avatar_is_selected_confirm_the_upload,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      avatarLoading:
          () => Text(
            S.of(context).uploading_an_avatar,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      avatarUploadSuccess:
          (url) => Text(
            S.of(context).the_avatar_has_been_uploaded_successfully,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      gallerySelected:
          (paths) => Text(
            S.of(context).add_a_profile_avatar,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      imagesUploadSuccess:
          (urls) => Text(
            S.of(context).add_a_profile_avatar,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      imagesLoading:
          () => Text(
            S.of(context).add_a_profile_avatar,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      error:
          (message) => Text(
            "${S.of(context).error} $message",
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
    );
  }
}
