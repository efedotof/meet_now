import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

class InventoryItemDetailsSheet extends StatefulWidget {
  final UserInventory inventoryItem;

  const InventoryItemDetailsSheet({super.key, required this.inventoryItem});

  @override
  State<InventoryItemDetailsSheet> createState() =>
      _InventoryItemDetailsSheetState();
}

class _InventoryItemDetailsSheetState extends State<InventoryItemDetailsSheet> {
  late Future<UserInventory> _processedInventoryFuture;

  @override
  void initState() {
    super.initState();
    _processedInventoryFuture = _processInventoryItem();
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
      debugPrint('Ошибка при обработке URL для подарка ${gift.id}: $e');
      return widget.inventoryItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserInventory>(
      future: _processedInventoryFuture,
      builder: (context, snapshot) {
        final inventoryItem = snapshot.data ?? widget.inventoryItem;
        final gift = inventoryItem.gift;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:
                    isLoading
                        ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : CachedNetworkImage(
                          imageUrl: gift.imageUrl,
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                          placeholder:
                              (context, url) => Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget: (context, url, error) {
                            debugPrint(
                              'Ошибка загрузки изображения инвентаря: $url, $error',
                            );
                            return Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wallet_giftcard,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Не удалось загрузить',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              const SizedBox(height: 16),
              Text(gift.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                gift.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Chip(
                    label: Text(gift.rarity.displayName),
                    backgroundColor: Color(
                      int.parse(gift.rarity.color.replaceAll('#', '0xFF')),
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  if (inventoryItem.receivedFromId != null)
                    const Chip(
                      label: Text('От друга'),
                      avatar: Icon(Icons.person, size: 16),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Получено: ${_formatDate(inventoryItem.receivedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Количество: ${inventoryItem.quantity}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
