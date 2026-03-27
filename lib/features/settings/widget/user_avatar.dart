import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, this.avatarKey, required this.radius});

  final String? avatarKey;
  final double radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String? _presignedUrl;
  bool _isLoading = false;
  bool _isValidUrl = false;
  StreamSubscription<FileResponse>? _cacheSubscription;
  File? _cachedFile;

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return false;
    }

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPresignedUrl();
  }

  @override
  void didUpdateWidget(UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.avatarKey != oldWidget.avatarKey) {
      _loadPresignedUrl();
    }
  }

  @override
  void dispose() {
    _cacheSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadPresignedUrl() async {
    if (widget.avatarKey == null || _isLoading) return;

    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final cubit = context.read<UploadsAvatarsCubit>();
      final url = await cubit.getPresignedUrl(widget.avatarKey!);

      if (!mounted) return;

      setState(() {
        _presignedUrl = url;
        _isValidUrl = _isValidImageUrl(url);
      });

      _precacheImage(url);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _presignedUrl = null;
        _isValidUrl = false;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _precacheImage(String url) async {
    final cacheManager = DefaultCacheManager();

    _cacheSubscription?.cancel();
    _cacheSubscription = cacheManager
        .getFileStream(url, withProgress: true)
        .listen((fileResponse) {
          if (fileResponse is FileInfo) {
            if (mounted) {
              setState(() {
                _cachedFile = fileResponse.file;
              });
            }
          }
        }, onError: (error) {});
  }

  ImageProvider? _getImageProvider() {
    if (_cachedFile != null && _cachedFile!.existsSync()) {
      return FileImage(_cachedFile!);
    } else if (_isValidUrl && _presignedUrl != null) {
      return NetworkImage(_presignedUrl!);
    }
    return null;
  }

  void _openFullscreenView() {
    final url = _presignedUrl;
    if (!_isValidUrl || url == null) {
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FullscreenMediaView(
              urlMedia: true,
              urlMedial: url,
              showSelectionIndicator: false,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: SizedBox(
          width: widget.radius * 0.8,
          height: widget.radius * 0.8,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }

    final imageProvider = _getImageProvider();

    if (imageProvider != null) {
      return GestureDetector(
        onTap: _openFullscreenView,
        child: CircleAvatar(
          radius: widget.radius,
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage: imageProvider,
          onBackgroundImageError: (exception, stackTrace) {
            if (mounted) {
              setState(() {
                _isValidUrl = false;
                _cachedFile = null;
              });
            }
          },
        ),
      );
    }

    return CircleAvatar(
      radius: widget.radius,
      child: Icon(
        Icons.person,
        size: widget.radius,
        color:
            Theme.brightnessOf(context) == Brightness.dark
                ? Colors.black
                : Colors.white,
      ),
    );
  }
}
