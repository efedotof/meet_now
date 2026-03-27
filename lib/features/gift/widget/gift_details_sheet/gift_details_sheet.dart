import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/gifts/gift/gift.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

import 'cost_chip.dart';
import 'image_shimmer.dart';
import 'rarity_chip.dart';
import 'sold_out_button.dart';

class GiftDetailsSheet extends StatefulWidget {
  final Gift gift;
  final GiftCubit giftCubit;

  const GiftDetailsSheet({
    super.key,
    required this.gift,
    required this.giftCubit,
  });

  @override
  State<GiftDetailsSheet> createState() => _GiftDetailsSheetState();
}

class _GiftDetailsSheetState extends State<GiftDetailsSheet>
    with SingleTickerProviderStateMixin {
  late Future<Gift> _processedGiftFuture;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isBuying = false;

  @override
  void initState() {
    super.initState();

    _processedGiftFuture = _processGiftUrl();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
      return gift;
    }
  }

  Future<void> _buyGift() async {
    final gamePointsCubit = context.read<GamePointsCubit>();
    final currentPoints = gamePointsCubit.currentPoints;

    if (currentPoints == null || currentPoints < widget.gift.costPoints) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${S.of(context).not_enough_points_to_purchase_you_need} ${widget.gift.costPoints}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            title: Text(S.of(context).purchase_confirmation),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).do_you_want_to_buy}"${widget.gift.name}"?',
                ),
                const SizedBox(height: 8),
                Text(
                  '${S.of(context).cost} ${widget.gift.costPoints} ${S.of(context).points}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(S.of(context).buy),
              ),
            ],
          ),
    );

    if (confirmed != true) {
      return;
    }

    if (!mounted) return;
    setState(() => _isBuying = true);

    try {
      await widget.giftCubit.buyGift(giftId: widget.gift.id);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).purchaseError),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 24,
                      tooltip: S.of(context).close,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<Gift>(
                  future: _processedGiftFuture,
                  builder: (context, snapshot) {
                    final gift = snapshot.data ?? widget.gift;
                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting;

                    final currentPoints =
                        context.watch<GamePointsCubit>().currentPoints;
                    final hasEnoughPoints =
                        currentPoints != null &&
                        currentPoints >= gift.costPoints;

                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        children: [
                          Center(
                            child: Hero(
                              tag: 'gift_image_${gift.id}',
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child:
                                    isLoading
                                        ? const ImageShimmer()
                                        : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: gift.imageUrl,
                                            fit: BoxFit.contain,
                                            placeholder:
                                                (_, _) => const ImageShimmer(),
                                            errorWidget:
                                                (_, _, _) => ErrorWidget(
                                                  S
                                                      .of(context)
                                                      .failedToLoadImage,
                                                ),
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            gift.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            gift.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              RarityChip(gift: gift),
                              CostChip(gift: gift),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (gift.isLimited) ...[
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withAlpha(30),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  S.of(context).limited_edition,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (currentPoints != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    Theme.brightnessOf(context) ==
                                            Brightness.dark
                                        ? Colors.black87
                                        : Colors.white60,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).your_balance,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$currentPoints ${S.of(context).points}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          hasEnoughPoints
                                              ? Colors.green
                                              : Colors.red,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 12),
                          if (gift.availableQuantity != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    Theme.brightnessOf(context) ==
                                            Brightness.dark
                                        ? Colors.black87
                                        : Colors.white60,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).available,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${gift.availableQuantity} ${S.of(context).pc}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),
                          if (gift.availableQuantity == null ||
                              gift.availableQuantity! > 0)
                            ElevatedButton(
                              onPressed: _isBuying ? null : _buyGift,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    hasEnoughPoints
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[400],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: hasEnoughPoints ? 4 : 0,
                              ),
                              child:
                                  _isBuying
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        hasEnoughPoints
                                            ? S.of(context).buy
                                            : S.of(context).not_enough_points,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            )
                          else if (gift.availableQuantity != null &&
                              gift.availableQuantity! <= 0)
                            const SoldOutButton(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
