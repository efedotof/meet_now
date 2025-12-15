import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';
import 'package:meet_now_app_server/model/gifts/admin_create_gift_request/admin_create_gift_request.dart';
import 'package:meet_now_app_server/model/social/city/city_create_request/city_create_request.dart';
import 'package:meet_now_app_server/model/social/icebreaker_topec/icebreaker_create_request/icebreaker_create_request.dart';
import 'package:meet_now_app_server/model/social/interes/interest_create_request/interest_create_request.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose_create_request/purpose_create_request.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker_create_request/sticker_create_request.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack_create_request/sticker_pack_create_request.dart';

import 'form/create_form.dart';

class ContentHeader extends StatefulWidget {
  const ContentHeader({super.key});

  @override
  State<ContentHeader> createState() => _ContentHeaderState();
}

class _ContentHeaderState extends State<ContentHeader> {
  final TextEditingController nameGiftController = TextEditingController();
  final TextEditingController descriptionGiftController =
      TextEditingController();
  final TextEditingController imageUrlGiftController = TextEditingController();
  final TextEditingController animationUrlGiftController =
      TextEditingController();
  final TextEditingController giftTypeGiftController = TextEditingController();
  final TextEditingController rarityIdGiftController = TextEditingController();
  final TextEditingController costPointsGiftController =
      TextEditingController();

  final TextEditingController nameCityController = TextEditingController();

  final TextEditingController textIcebreakerController =
      TextEditingController();

  final TextEditingController titleInterestController = TextEditingController();

  final TextEditingController titlePurposeController = TextEditingController();

  final TextEditingController packIdStickerController = TextEditingController();
  final TextEditingController emojiStickerController = TextEditingController();
  final TextEditingController imageUrlStickerController =
      TextEditingController();

  final TextEditingController titleStickerPackController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        final title = _getTitle(state.currentContentType);
        final subtitle = _getSubtitle(state.currentContentType);
        final count = _getItemCount(state);

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$subtitle • $count элементов',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const Spacer(),

              // _buildActionButton(context, state.currentContentType),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withAlpha(3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () =>
                      _showCreateDialog(context, state.currentContentType),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Добавить',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _getItemCount(ContentState state) {
    switch (state.currentContentType) {
      case ContentType.cities:
        return state.cities?.length ?? 0;
      case ContentType.icebreakers:
        return state.icebreakers?.length ?? 0;
      case ContentType.interests:
        return state.interests?.length ?? 0;
      case ContentType.purposes:
        return state.purposes?.length ?? 0;
      case ContentType.stickerPacks:
        return state.stickerPacks?.length ?? 0;
      case ContentType.stickers:
        return state.stickers?.length ?? 0;
      case ContentType.games:
        return state.games?.length ?? 0;
      case ContentType.gifts:
        return state.gifts?.length ?? 0;
    }
  }

  String _getTitle(ContentType type) {
    switch (type) {
      case ContentType.cities:
        return 'Города';
      case ContentType.icebreakers:
        return 'Темы для разговора';
      case ContentType.interests:
        return 'Интересы';
      case ContentType.purposes:
        return 'Цели';
      case ContentType.stickerPacks:
        return 'Наборы стикеров';
      case ContentType.stickers:
        return 'Стикеры';
      case ContentType.games:
        return 'Игры';
      case ContentType.gifts:
        return 'Подарки';
    }
  }

  String _getSubtitle(ContentType type) {
    switch (type) {
      case ContentType.cities:
        return 'Управление городами пользователей';
      case ContentType.icebreakers:
        return 'Темы для начала разговора';
      case ContentType.interests:
        return 'Интересы пользователей';
      case ContentType.purposes:
        return 'Цели знакомств';
      case ContentType.stickerPacks:
        return 'Наборы стикеров для чата';
      case ContentType.stickers:
        return 'Отдельные стикеры';
      case ContentType.games:
        return 'Игры в чатах';
      case ContentType.gifts:
        return 'Подарки и их редкости';
    }
  }

  void _showCreateDialog(BuildContext context, ContentType type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Создание ${_getTitle(type).toLowerCase()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 400),
          child: CreateForm(
            type: type,
            nameGiftController: nameGiftController,
            descriptionGiftController: descriptionGiftController,
            imageUrlGiftController: imageUrlGiftController,
            animationUrlGiftController: animationUrlGiftController,
            giftTypeGiftController: giftTypeGiftController,
            rarityIdGiftController: rarityIdGiftController,
            costPointsGiftController: costPointsGiftController,
            nameCityController: nameCityController,
            textIcebreakerController: textIcebreakerController,
            titleInterestController: titleInterestController,
            titlePurposeController: titlePurposeController,
            packIdStickerController: packIdStickerController,
            emojiStickerController: emojiStickerController,
            imageUrlStickerController: imageUrlStickerController,
            titleStickerPackController: titleStickerPackController,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              switch (type) {
                case ContentType.cities:
                  context.read<ContentCubit>().createCity(
                    CityCreateRequest(name: nameCityController.text),
                  );
                  break;
                case ContentType.icebreakers:
                  context.read<ContentCubit>().createTopic(
                    IcebreakerCreateRequest(
                      text: textIcebreakerController.text,
                    ),
                  );
                  break;
                case ContentType.interests:
                  context.read<ContentCubit>().createInterest(
                    InterestCreateRequest(title: titleInterestController.text),
                  );
                  break;
                case ContentType.purposes:
                  context.read<ContentCubit>().createPurpose(
                    PurposeCreateRequest(title: titlePurposeController.text),
                  );
                  break;
                case ContentType.stickerPacks:
                  context.read<ContentCubit>().createStickerPack(
                    StickerPackCreateRequest(
                      title: titleStickerPackController.text,
                    ),
                  );
                  break;
                case ContentType.stickers:
                  context.read<ContentCubit>().createSticker(
                    StickerCreateRequest(
                      packId: packIdStickerController.text,
                      emoji: emojiStickerController.text,
                      imageUrl: imageUrlStickerController.text,
                    ),
                  );
                  break;
                case ContentType.games:
                  break;
                case ContentType.gifts:
                  context.read<ContentCubit>().createGift(
                    AdminCreateGiftRequest(
                      name: nameGiftController.text,
                      description: descriptionGiftController.text,
                      imageUrl: imageUrlGiftController.text,
                      animationUrl: animationUrlGiftController.text,
                      giftType: giftTypeGiftController.text,
                      rarityId: rarityIdGiftController.text,
                      costPoints: int.parse(costPointsGiftController.text),
                      availableQuantity: 0,//TODO: добавить
                      isLimited: false,//TODO: добавить
                      initialQuantity: 0, //TODO: добавить
                    ),
                  );
                  break;
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }
}
