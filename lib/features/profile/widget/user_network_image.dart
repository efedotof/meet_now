import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

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
            () => context.pushRoute(FullImageRoute(imageUrl: _presignedUrl!)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            _presignedUrl!,
            fit: widget.fit,
            errorBuilder:
                (context, error, stackTrace) => Center(
                  child: IconButton(
                    icon: const Icon(Icons.broken_image, color: Colors.grey),
                    tooltip: S.of(context).failed_to_load_image_click_to_retry,
                    onPressed: _loadPresignedUrl,
                  ),
                ),
          ),
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
