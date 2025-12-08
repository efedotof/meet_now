import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.state,
    required this.cubit,
    required this.onPickAvatar,
    required this.onAvatarConfirmedChange,
  });
  final UploadsAvatarsState state;
  final UploadsAvatarsCubit cubit;
  final VoidCallback onPickAvatar;
  final ValueChanged<bool> onAvatarConfirmedChange;
  @override
  Widget build(BuildContext context) {
    return state.when(
      initial:
          () => ElevatedButton(
            onPressed: onPickAvatar,
            child: Text(S.of(context).choose_an_avatar),
          ),
      avatarSelected:
          (uri, bytes) => Column(
            children: [
              ElevatedButton(
                onPressed: () => cubit.confirmAndUploadAvatar(),
                child: Text(S.of(context).confirm_and_upload_your_avatar),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: cubit.removeAvatar,
                child: Text(S.of(context).delete_an_avatar),
              ),
            ],
          ),
      avatarUploadSuccess:
          (url) => Column(
            children: [
              ElevatedButton(
                onPressed: onPickAvatar,
                child: Text(S.of(context).change_your_avatar),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  cubit.removeAvatar();
                  onAvatarConfirmedChange(false);
                },
                child: Text(S.of(context).delete_an_avatar),
              ),
            ],
          ),
      gallerySelected:
          (paths) => ElevatedButton(
            onPressed: onPickAvatar,
            child: Text(S.of(context).choose_an_avatar),
          ),
      imagesUploadSuccess:
          (urls) => ElevatedButton(
            onPressed: onPickAvatar,
            child: Text(S.of(context).choose_an_avatar),
          ),
      imagesLoading:
          () => ElevatedButton(
            onPressed: onPickAvatar,
            child: Text(S.of(context).choose_an_avatar),
          ),
      error:
          (message) => ElevatedButton(
            onPressed: onPickAvatar,
            child: Text(S.of(context).choose_an_avatar),
          ),
      avatarLoading: () => const SizedBox(),
    );
  }
}
