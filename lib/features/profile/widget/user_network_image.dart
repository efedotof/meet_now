import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class UserNetworkImage extends StatefulWidget {
  const UserNetworkImage({
    super.key,
    required this.imageKey,
    required this.allImageKeys,
    required this.index,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheManager,
  });

  final String imageKey;
  final List<String> allImageKeys;
  final int index;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BaseCacheManager? cacheManager;

  @override
  State<UserNetworkImage> createState() => _UserNetworkImageState();
}

class _UserNetworkImageState extends State<UserNetworkImage> {
  String? _presignedUrl;
  bool _isLoading = false;
  bool _hasError = false;
  bool _showDeleteIcon = false;
  StreamSubscription<FileResponse>? _cacheSubscription;
  File? _cachedFile;
  final _defaultCacheManager = DefaultCacheManager();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPresignedUrl();
  }

  @override
  void dispose() {
    _cacheSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadPresignedUrl() async {
    if (_isLoading) return;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final cubit = context.read<UploadsAvatarsCubit>();
      final url = await cubit.getPresignedUrl(widget.imageKey);

      if (!mounted) return;

      setState(() => _presignedUrl = url);
      _subscribeToCacheStream(url);
    } catch (e) {
      if (!mounted) return;
      setState(() => _hasError = true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _subscribeToCacheStream(String url) {
    final cacheManager = widget.cacheManager ?? _defaultCacheManager;

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

  Future<List<String?>> _loadAllPresignedUrls() async {
    final cubit = context.read<UploadsAvatarsCubit>();
    final results = <String?>[];

    for (final key in widget.allImageKeys) {
      try {
        final url = await cubit.getPresignedUrl(key);
        results.add(url);
      } catch (e) {
        results.add(null);
      }
    }

    return results;
  }

  Future<void> _precacheNextImages() async {
    final nextIndex = widget.index + 1;
    if (nextIndex < widget.allImageKeys.length) {
      final nextImageKey = widget.allImageKeys[nextIndex];
      final cubit = context.read<UploadsAvatarsCubit>();

      unawaited(() async {
        try {
          final url = await cubit.getPresignedUrl(nextImageKey);
          final cacheManager = widget.cacheManager ?? _defaultCacheManager;
          await cacheManager.downloadFile(url);
        } catch (e) {
          //
        }
      }());
    }
  }

  void _openFullscreenView() async {
    await _precacheNextImages();

    final urls = await _loadAllPresignedUrls();

    final validUrls =
        urls
            .where((url) => url != null && url.isNotEmpty)
            .cast<String>()
            .toList();

    if (validUrls.isEmpty) {
      return;
    }

    int currentIndex = 0;
    if (_presignedUrl != null) {
      final currentUrl = _presignedUrl!;
      final indexInValidUrls = validUrls.indexOf(currentUrl);
      if (indexInValidUrls != -1) {
        currentIndex = indexInValidUrls;
      } else {
        currentIndex = widget.index.clamp(0, validUrls.length - 1);
      }
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FullscreenMediaView(
              urlMedia: true,
              urlMedias: validUrls,
              initialIndex: currentIndex,
              showSelectionIndicator: false,
            ),
      ),
    );
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

    if (confirm == true && mounted) {
      await context.read<UploadsAvatarsCubit>().deleteUserImage(
        imageUrl: widget.imageKey,
      );

      if (mounted) {
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
        onTap: _openFullscreenView,
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
              child:
                  _cachedFile != null && _cachedFile!.existsSync()
                      ? Image.file(
                        _cachedFile!,
                        fit: widget.fit,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            _presignedUrl!,
                            fit: widget.fit,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              );
                            },
                            errorBuilder:
                                (context, error, stackTrace) => Center(
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                    tooltip:
                                        S
                                            .of(context)
                                            .failed_to_load_image_click_to_retry,
                                    onPressed: _loadPresignedUrl,
                                  ),
                                ),
                          );
                        },
                      )
                      : Image.network(
                        _presignedUrl!,
                        fit: widget.fit,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                                tooltip:
                                    S
                                        .of(context)
                                        .failed_to_load_image_click_to_retry,
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
