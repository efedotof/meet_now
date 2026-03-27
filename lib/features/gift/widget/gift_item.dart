import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';

class GiftItem extends StatefulWidget {
  final Gift gift;
  final VoidCallback onTap;
  final VoidCallback? onBuyTap;
  final int? count;
  final bool isInShop;

  const GiftItem({
    super.key,
    required this.gift,
    required this.onTap,
    this.onBuyTap,
    this.count,
    this.isInShop = false,
  });

  @override
  State<GiftItem> createState() => _GiftItemState();
}

class _GiftItemState extends State<GiftItem> {
  bool isBuying = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.white70 : Colors.black87,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.gift.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder:
                    (context, url) => Container(
                      color: isDark ? Colors.white12 : Colors.black12,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: isDark ? Colors.white24 : Colors.black26,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.g_mobiledata,
                            size: 40,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            S.of(context).failed_to_upload,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDark ? Colors.white70 : Colors.black87,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      " ${widget.gift.currentPrice ?? ""} ${S.of(context).points}",
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  if (widget.isInShop && widget.onBuyTap != null)
                    GestureDetector(
                      onTap:
                          isBuying
                              ? null
                              : () {
                                setState(() => isBuying = true);
                                widget.onBuyTap?.call();
                                if (mounted) {
                                  setState(() => isBuying = false);
                                }
                              },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              isBuying
                                  ? Colors.grey
                                  : isDark
                                  ? Colors.white70
                                  : Colors.black87,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child:
                            isBuying
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                ],
              ),
            ),
            if (!widget.isInShop && widget.count != null && widget.count! > 1)
              Positioned(
                right: 3,
                bottom: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.blue.withAlpha(80),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  child: Text(
                    '×${widget.count}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (widget.gift.isLimited)
              Positioned(
                left: 3,
                bottom: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.orange.withAlpha(80),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  child: Text(
                    S.of(context).limited,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            if (widget.gift.isSoldOut)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.black54,
                  ),
                  child: Center(
                    child: Text(
                      S.of(context).sold_out,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
