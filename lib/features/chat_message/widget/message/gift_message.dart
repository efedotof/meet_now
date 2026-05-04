import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';
import 'package:meet_now_app_server/model/chats/message/message.dart';
import 'package:meet_now_app_server/model/gifts/gift_rarity/gift_rarity.dart';

class GiftMessage extends StatefulWidget {
  final Message message;
  final bool isMe;
  final ThemeData theme;

  const GiftMessage({
    super.key,
    required this.message,
    required this.isMe,
    required this.theme,
  });

  @override
  State<GiftMessage> createState() => _GiftMessageState();
}

class _GiftMessageState extends State<GiftMessage> {
  static final Map<String, String> _urlCache = {};
  String? _displayUrl;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _prepareUrl();
  }

  @override
  void didUpdateWidget(covariant GiftMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.gift?.id != widget.message.gift?.id) {
      _prepareUrl();
    }
  }

  void _prepareUrl() {
    final gift = widget.message.gift;
    if (gift == null) {
      setState(() {
        _displayUrl = null;
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    final originalUrl =
        (gift.animationUrl != null && gift.animationUrl!.isNotEmpty)
            ? gift.animationUrl!
            : gift.imageUrl;

    if (_urlCache.containsKey(originalUrl)) {
      setState(() {
        _displayUrl = _urlCache[originalUrl];
        _isLoading = false;
        _hasError = false;
      });
    } else {
      setState(() {
        _isLoading = true;
        _hasError = false;
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
      if (mounted) {
        final currentOriginalUrl =
            (widget.message.gift?.animationUrl != null &&
                    widget.message.gift!.animationUrl!.isNotEmpty)
                ? widget.message.gift!.animationUrl!
                : widget.message.gift?.imageUrl ?? '';
        if (currentOriginalUrl == originalUrl) {
          setState(() {
            _displayUrl = presignedUrl;
            _isLoading = false;
            _hasError = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        final currentOriginalUrl =
            (widget.message.gift?.animationUrl != null &&
                    widget.message.gift!.animationUrl!.isNotEmpty)
                ? widget.message.gift!.animationUrl!
                : widget.message.gift?.imageUrl ?? '';
        if (currentOriginalUrl == originalUrl) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      }
    }
  }

  void _retry() {
    final gift = widget.message.gift;
    if (gift != null) {
      final originalUrl =
          (gift.animationUrl != null && gift.animationUrl!.isNotEmpty)
              ? gift.animationUrl!
              : gift.imageUrl;
      _urlCache.remove(originalUrl);
      _prepareUrl();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gift = widget.message.gift;
    final scheme = widget.theme.colorScheme;
    final rarityColor =
        gift != null ? _getRarityColor(gift.rarity) : scheme.primary;

    return Center(
      child: GestureDetector(
        onTap: gift != null ? () => _showGiftDetails(context, gift) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: rarityColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isLoading) CircularProgressIndicator(color: rarityColor),
                  if (_hasError && !_isLoading)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard, size: 64, color: rarityColor),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _retry,
                          child: Text(
                            'Повторить',
                            style: TextStyle(color: rarityColor),
                          ),
                        ),
                      ],
                    ),
                  if (_displayUrl != null && !_hasError)
                    CachedNetworkImage(
                      imageUrl: _displayUrl!,
                      fit: BoxFit.contain,
                      width: 120,
                      height: 120,
                      cacheKey: gift?.id,
                      placeholder:
                          (_, _) =>
                              CircularProgressIndicator(color: rarityColor),
                      errorWidget: (_, _, _) {
                        final originalUrl =
                            (gift?.animationUrl != null &&
                                    gift!.animationUrl!.isNotEmpty)
                                ? gift.animationUrl!
                                : gift?.imageUrl ?? '';
                        _urlCache.remove(originalUrl);
                        return Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: rarityColor,
                        );
                      },
                    ),
                  if (gift?.animationUrl != null &&
                      gift!.animationUrl!.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.isMe ? 'Вы отправили подарок' : 'Вам отправили подарок',
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGiftDetails(BuildContext context, gift) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                gift.name,
                style: widget.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                gift.description,
                style: widget.theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text('${gift.costPoints}'),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Color _getRarityColor(GiftRarity rarity) {
    switch (rarity.name) {
      case 'COMMON':
        return Colors.grey;
      case 'UNCOMMON':
        return Colors.green;
      case 'RARE':
        return Colors.blue;
      case 'EPIC':
        return Colors.purple;
      case 'LEGENDARY':
        return Colors.orange;
      default:
        return widget.theme.colorScheme.primary;
    }
  }
}
