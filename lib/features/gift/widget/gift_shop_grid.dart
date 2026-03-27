import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/widget/gift_item.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

class GiftShopGrid extends StatefulWidget {
  final List<Gift> gifts;
  final Function(Gift) onGiftTap;
  final void Function(Gift) onBuyGift;
  final bool isMobile;

  const GiftShopGrid({
    super.key,
    required this.gifts,
    required this.onGiftTap,
    required this.onBuyGift,
    required this.isMobile,
  });

  @override
  State<GiftShopGrid> createState() => _GiftShopGridState();
}

class _GiftShopGridState extends State<GiftShopGrid>
    with AutomaticKeepAliveClientMixin {
  final Map<String, String> _imageUrlCache = {};
  final Map<String, String> _animationUrlCache = {};
  final Map<String, Gift> _processedGiftsCache = {};
  bool _isProcessing = false;

  @override
  bool get wantKeepAlive => true;

  Future<void> _processGiftsUrls() async {
    if (_isProcessing || widget.gifts.isEmpty) return;

    _isProcessing = true;
    final uploadImageInterface = context.read<UploadImageInterface>();

    for (final gift in widget.gifts) {
      if (_processedGiftsCache.containsKey(gift.id)) continue;

      try {
        String? imagePresignedUrl = _imageUrlCache[gift.imageUrl];
        if (imagePresignedUrl == null) {
          imagePresignedUrl = await uploadImageInterface.getPresignedUrl(
            gift.imageUrl,
          );
          _imageUrlCache[gift.imageUrl] = imagePresignedUrl;
        }

        String? animationPresignedUrl;
        if (gift.animationUrl != null) {
          animationPresignedUrl = _animationUrlCache[gift.animationUrl!];
          if (animationPresignedUrl == null) {
            animationPresignedUrl = await uploadImageInterface.getPresignedUrl(
              gift.animationUrl!,
            );
            _animationUrlCache[gift.animationUrl!] = animationPresignedUrl;
          }
        }

        final processedGift = gift.copyWith(
          imageUrl: animationPresignedUrl ?? imagePresignedUrl,
          animationUrl: animationPresignedUrl,
        );

        _processedGiftsCache[gift.id] = processedGift;
      } catch (e) {
        _processedGiftsCache[gift.id] = gift;
      }
    }

    _isProcessing = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processGiftsUrls();
    });
  }

  @override
  void didUpdateWidget(GiftShopGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.gifts != oldWidget.gifts) {
      final oldIds = oldWidget.gifts.map((g) => g.id).toSet();
      final newIds = widget.gifts.map((g) => g.id).toSet();

      final removedIds = oldIds.difference(newIds);
      for (final id in removedIds) {
        _processedGiftsCache.remove(id);
      }
      _processGiftsUrls();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.gifts.isEmpty || _processedGiftsCache.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final giftsToDisplay =
        widget.gifts.map((gift) {
          return _processedGiftsCache[gift.id] ?? gift;
        }).toList();

    return GridView.builder(
      padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isMobile ? 2 : 3,
        crossAxisSpacing: widget.isMobile ? 16 : 24,
        mainAxisSpacing: widget.isMobile ? 16 : 24,
        childAspectRatio: widget.isMobile ? 0.75 : 0.8,
      ),
      itemCount: widget.gifts.length,
      itemBuilder: (context, index) {
        final gift = giftsToDisplay[index];
        final originalGift = widget.gifts[index];

        return GiftItem(
          gift: gift,
          onTap: () => widget.onGiftTap(originalGift),
          onBuyTap: () => widget.onBuyGift(originalGift),
          isInShop: true,
        );
      },
    );
  }
}
