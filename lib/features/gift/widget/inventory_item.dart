import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

class InventoryItem extends StatefulWidget {
  final UserInventory inventoryItem;
  final VoidCallback onTap;
  final bool isInShop;

  const InventoryItem({
    super.key,
    required this.inventoryItem,
    required this.onTap,
    this.isInShop = false,
  });

  @override
  State<InventoryItem> createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  late Future<UserInventory> _processedInventoryFuture;

  @override
  void initState() {
    super.initState();
    _processedInventoryFuture = _processInventoryItem();
  }

  @override
  void didUpdateWidget(InventoryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.inventoryItem != widget.inventoryItem) {
      _processedInventoryFuture = _processInventoryItem();
    }
  }

  Future<UserInventory> _processInventoryItem() async {
    final uploadImageInterface = context.read<UploadImageInterface>();
    final gift = widget.inventoryItem.gift;

    try {
      final imagePresignedUrl = await uploadImageInterface.getPresignedUrl(
        gift.imageUrl,
      );

      String? animationPresignedUrl;
      if (gift.animationUrl != null) {
        animationPresignedUrl = await uploadImageInterface.getPresignedUrl(
          gift.animationUrl!,
        );
      }

      final processedGift = gift.copyWith(
        imageUrl: animationPresignedUrl ?? imagePresignedUrl,
        animationUrl: animationPresignedUrl,
      );

      return widget.inventoryItem.copyWith(gift: processedGift);
    } catch (e) {
      return widget.inventoryItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return FutureBuilder<UserInventory>(
      future: _processedInventoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: isDark ? Colors.white12 : Colors.black12,
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: isDark ? Colors.white12 : Colors.black12,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).download_error,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final processedItem = snapshot.data!;

        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: CachedNetworkImage(
                    imageUrl: processedItem.gift.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder:
                        (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                    errorWidget: (context, url, error) {
                      return Container(
                        color: isDark ? Colors.white24 : Colors.black26,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wallet_giftcard,
                              size: 40,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              S.of(context).download_error,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                if (processedItem.quantity > 1)
                  Positioned(
                    right: 3,
                    top: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      child: Text(
                        "×${processedItem.quantity}",
                        style: TextStyle(
                          color: isDark ? Colors.black : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  left: 3,
                  bottom: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!processedItem.isVisible)
                          Icon(
                            Icons.visibility_off,
                            size: 12,
                            color: isDark ? Colors.black54 : Colors.white70,
                          ),
                        const SizedBox(width: 2),
                        Text(
                          _formatDate(processedItem.receivedAt),
                          style: TextStyle(
                            color: isDark ? Colors.black : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (processedItem.receivedFromId != null &&
                    processedItem.receivedFromId!.isNotEmpty)
                  Positioned(
                    left: 3,
                    top: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.blue.withAlpha(80),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${S.of(context).year}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${S.of(context).month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${S.of(context).day}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${S.of(context).hour}';
    } else {
      return S.of(context).just_now;
    }
  }
}
