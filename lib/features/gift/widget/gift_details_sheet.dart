import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/gifts/buy_gift_response/buy_gift_response.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

class GiftDetailsSheet extends StatefulWidget {
  final Gift gift;

  const GiftDetailsSheet({super.key, required this.gift});

  @override
  State<GiftDetailsSheet> createState() => _GiftDetailsSheetState();
}

class _GiftDetailsSheetState extends State<GiftDetailsSheet> {
  late Future<Gift> _processedGiftFuture;
  bool _isBuying = false;

  @override
  void initState() {
    super.initState();
    _processedGiftFuture = _processGiftUrl();
  }

  Future<Gift> _processGiftUrl() async {
    final uploadImageInterface = context.read<UploadImageInterface>();
    final gift = widget.gift;

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

      return gift.copyWith(
        imageUrl: animationPresignedUrl ?? imagePresignedUrl,
        animationUrl: animationPresignedUrl,
      );
    } catch (e) {
      debugPrint('Ошибка при обработке URL для подарка ${gift.id}: $e');
      return gift;
    }
  }

  Future<void> _buyGift(BuildContext context) async {
    final gamePointsCubit = context.read<GamePointsCubit>();
    final gift = widget.gift;

    if (!gamePointsCubit.hasEnoughPoints(gift.costPoints)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${S.of(context).not_enough_points_to_purchase_you_need} ${gift.costPoints}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final shouldBuy = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).purchase_confirmation),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${S.of(context).do_you_want_to_buy} "${gift.name}"?'),
                const SizedBox(height: 8),
                Text(
                  '${S.of(context).cost} ${gift.costPoints} ${S.of(context).points}',
                ),
                const SizedBox(height: 4),
                Text(
                  '${S.of(context).your_balance} ${gamePointsCubit.currentPoints ?? 0} ${S.of(context).points}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(S.of(context).buy),
              ),
            ],
          ),
    );

    if (shouldBuy == true) {
      setState(() => _isBuying = true);
      try {
        if (context.mounted) {
          final response = await context.read<GiftCubit>().buyGift(
            giftId: gift.id,
          );

          if (response != null && mounted) {
            if (context.mounted) {
              _showPurchaseSuccess(context, response);
            }
          }
          if (context.mounted) {
            context.read<GamePointsCubit>().refreshPoints();
          }

          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${S.of(context).purchase_error} $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isBuying = false);
        }
      }
    }
  }

  void _showPurchaseSuccess(BuildContext context, BuyGiftResponse response) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).the_purchase_was_successful),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).you_have_purchased_a_gift} ${response.inventoryItem.gift.name}',
                ),
                const SizedBox(height: 8),
                Text('${S.of(context).points_spent} ${response.spentPoints}'),
                Text(
                  '${S.of(context).new_balance_sheet} ${response.newBalance}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).ok),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Gift>(
      future: _processedGiftFuture,
      builder: (context, snapshot) {
        final gift = snapshot.data ?? widget.gift;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        final currentPoints = context.read<GamePointsCubit>().currentPoints;
        final hasEnoughPoints =
            currentPoints != null && currentPoints >= gift.costPoints;

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
                              'Ошибка загрузки изображения подарка: $url, $error',
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
                                    Icons.gif_outlined,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    S.of(context).failed_to_upload,
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
                  Chip(
                    label: Text('${gift.costPoints} ${S.of(context).points}'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (currentPoints != null)
                Text(
                  '${S.of(context).your_balance} $currentPoints ${S.of(context).points}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: hasEnoughPoints ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (gift.availableQuantity != null)
                Text(
                  '${S.of(context).available} ${gift.availableQuantity} ${S.of(context).pc}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (gift.isLimited)
                Chip(
                  label: Text(S.of(context).limited_edition),
                  backgroundColor: Colors.orange.withAlpha(80),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              if (gift.availableQuantity != null && gift.availableQuantity! > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child:
                        _isBuying
                            ? ElevatedButton(
                              onPressed: null,
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            )
                            : ElevatedButton(
                              onPressed:
                                  hasEnoughPoints
                                      ? () => _buyGift(context)
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    hasEnoughPoints
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                              ),
                              child: Text(
                                hasEnoughPoints
                                    ? S.of(context).buy
                                    : S.of(context).not_enough_points,
                                style: TextStyle(
                                  color:
                                      hasEnoughPoints
                                          ? Colors.white
                                          : Colors.white70,
                                ),
                              ),
                            ),
                  ),
                ),
              if (gift.availableQuantity != null &&
                  gift.availableQuantity! <= 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).sold_out,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
