import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'errors_widget.dart';
import 'file_size_formatter.dart';
import 'loading_placeholder.dart';
import 'text_message.dart';

class ImageMessage extends StatefulWidget {
  final Message message;
  final ThemeData theme;
  final MessageMedia media;
  final bool isMe;

  const ImageMessage({
    super.key,
    required this.message,
    required this.theme,
    required this.media,
    required this.isMe,
  });

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  static final Map<String, String> _urlCache = {};

  String? _displayUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _prepareUrl();
  }

  @override
  void didUpdateWidget(ImageMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media.mediaUrl != oldWidget.media.mediaUrl) {
      _prepareUrl();
    }
  }

  void _prepareUrl() {
    final originalUrl = widget.media.mediaUrl;
    if (originalUrl == null || originalUrl.isEmpty) {
      setState(() {
        _displayUrl = null;
        _isLoading = false;
      });
      return;
    }

    if (_urlCache.containsKey(originalUrl)) {
      setState(() {
        _displayUrl = _urlCache[originalUrl];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = true;
        _displayUrl = null;
      });
      _fetchPresignedUrl(originalUrl);
    }
  }

  Future<void> _fetchPresignedUrl(String originalUrl) async {
    try {
      final uploadImageInterface = context.read<UploadImageInterface>();
      final presignedUrl = await uploadImageInterface.getPresignedUrl(
        originalUrl,
      );
      _urlCache[originalUrl] = presignedUrl;
      if (mounted && widget.media.mediaUrl == originalUrl) {
        setState(() {
          _displayUrl = presignedUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted && widget.media.mediaUrl == originalUrl) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _retry() {
    final originalUrl = widget.media.mediaUrl;
    if (originalUrl != null && originalUrl.isNotEmpty) {
      _urlCache.remove(originalUrl);
      _prepareUrl();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTemp = widget.message.id?.startsWith('temp') ?? false;
    final hasUrl = _displayUrl != null && _displayUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                if (isTemp && !hasUrl)
                  LoadingPlaceholder()
                else if (hasUrl)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => FullscreenMediaView(
                                urlMedia: true,
                                showSelectionIndicator: false,
                                urlMedias: [_displayUrl!],
                              ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: _displayUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      cacheKey: widget.media.mediaUrl,
                      memCacheHeight: 440,
                      memCacheWidth: 440,
                      placeholder: (_, _) => LoadingPlaceholder(),
                      errorWidget: (_, _, _) {
                        _urlCache.remove(widget.media.mediaUrl);
                        return ErrorsWidget(onRetry: _retry);
                      },
                    ),
                  )
                else if (_isLoading)
                  LoadingPlaceholder()
                else
                  ErrorsWidget(onRetry: _retry),

                if (widget.media.fileSize != null)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        FileSizeFormatter.format(widget.media.fileSize!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                if (hasUrl)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fullscreen_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.message.text.isNotEmpty) ...[
          const SizedBox(height: 12),
          TextMessage(
            message: widget.message,
            isMe: widget.isMe,
            theme: widget.theme,
          ),
        ],
      ],
    );
  }
}
