import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class UserNetworkImage extends StatefulWidget {
  const UserNetworkImage({
    super.key,
    required this.imageKey,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageKey;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  State<UserNetworkImage> createState() => _UserNetworkImageState();
}

class _UserNetworkImageState extends State<UserNetworkImage> {
  String? _presignedUrl;
  bool _isLoading = false;
  bool _hasError = false;
  bool _showDeleteIcon = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPresignedUrl();
  }

  Future<void> _loadPresignedUrl() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final cubit = context.read<UploadsAvatarsCubit>();
      final url = await cubit.getPresignedUrl(widget.imageKey);

      if (mounted) {
        setState(() => _presignedUrl = url);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _requestDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(S.of(context).delete),
            content: Text(S.of(context).confirm_delete),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  S.of(context).delete,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      if (context.mounted) {
        await context.read<UploadsAvatarsCubit>().deleatUserImage(
          imageUrl: widget.imageKey,
        );
      }
      if (context.mounted) {
        await context.read<SettingsCubit>().getCurrentUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isLoading) {
      child = const Center(child: CircularProgressIndicator());
    } else if (_hasError || _presignedUrl == null) {
      child = Center(
        child: IconButton(
          icon: const Icon(Icons.refresh, color: Colors.red),
          tooltip: S.of(context).download_error_click_to_repeat,
          onPressed: _loadPresignedUrl,
        ),
      );
    } else {
      child = GestureDetector(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => FullscreenMediaView(
                      urlMedia: true,
                      urlMedial: _presignedUrl,
                    ),
              ),
            ),
        onLongPress: () {
          setState(() => _showDeleteIcon = true);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) setState(() => _showDeleteIcon = false);
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _presignedUrl!,
                fit: widget.fit,
                errorBuilder:
                    (context, error, stackTrace) => Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                        tooltip:
                            S.of(context).failed_to_load_image_click_to_retry,
                        onPressed: _loadPresignedUrl,
                      ),
                    ),
              ),
            ),
            if (_showDeleteIcon)
              Positioned(
                right: 6,
                top: 6,
                child: GestureDetector(
                  onTap: _requestDelete,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: child,
    );
  }
}
