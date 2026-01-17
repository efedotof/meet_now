import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

import 'action_buttons.dart';
import 'default_avatar.dart';
import 'loading_avatar.dart';
import 'selected_avatar.dart';
import 'status_text.dart';
import 'uploaded_avatar.dart';

class AvatarPage extends StatefulWidget {
  final UploadsAvatarsState state;
  final UploadsAvatarsCubit cubit;
  final VoidCallback onPickAvatar;
  final bool avatarConfirmed;
  final ValueChanged<bool> onAvatarConfirmedChange;

  const AvatarPage({
    super.key,
    required this.state,
    required this.cubit,
    required this.onPickAvatar,
    required this.avatarConfirmed,
    required this.onAvatarConfirmedChange,
  });

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  String? _presignedUrl;
  bool _isLoading = false;

  final Map<String, String> _presignedUrlCache = {};

  void _loadPresignedUrl(String url) async {
    if (_isLoading) return;

    if (_presignedUrlCache.containsKey(url)) {
      setState(() {
        _presignedUrl = _presignedUrlCache[url];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final presignedUrl = await widget.cubit.getPresignedUrl(url);

      if (mounted) {
        setState(() {
          _presignedUrl = presignedUrl;
          _presignedUrlCache[url] = presignedUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Ошибка получения presigned URL: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void didUpdateWidget(AvatarPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.state.whenOrNull(
      avatarUploadSuccess: (url) {
        if (_presignedUrl == null || !_presignedUrlCache.containsKey(url)) {
          _loadPresignedUrl(url);
        }
      },
      initial: () {
        if (_presignedUrl != null) {
          setState(() {
            _presignedUrl = null;
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state.maybeWhen(
      avatarLoading: () => true,
      orElse: () => false,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              widget.state.when(
                initial: () => DefaultAvatar(),
                avatarSelected:
                    (uri, bytes) =>
                        SelectedAvatar(bytes: bytes, cubit: widget.cubit),
                avatarLoading: () => LoadingAvatar(),
                avatarUploadSuccess:
                    (url) => UploadedAvatar(
                      url: url,
                      cubit: widget.cubit,
                      presignedUrl: _presignedUrl,
                      onAvatarConfirmedChange: widget.onAvatarConfirmedChange,
                    ),
                gallerySelected: (paths) => DefaultAvatar(),
                imagesUploadSuccess: (urls) => DefaultAvatar(),
                imagesLoading: () => DefaultAvatar(),
                error: (message) => DefaultAvatar(),
              ),
              if (isLoading || _isLoading) const CircularProgressIndicator(),
            ],
          ),
          const SizedBox(height: 20),
          StatusText(state: widget.state),
          const SizedBox(height: 20),
          if (!isLoading && !_isLoading)
            ActionButtons(
              state: widget.state,
              cubit: widget.cubit,
              onPickAvatar: widget.onPickAvatar,
              onAvatarConfirmedChange: widget.onAvatarConfirmedChange,
            ),
        ],
      ),
    );
  }
}
