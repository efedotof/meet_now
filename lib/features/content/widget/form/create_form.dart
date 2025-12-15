import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';

import 'city_form.dart';
import 'gift_form.dart';
import 'icebreaker_form.dart';
import 'interest_form.dart';
import 'purpose_form.dart';
import 'sticker_form.dart';
import 'sticker_pack_form.dart';

class CreateForm extends StatelessWidget {
  const CreateForm({
    super.key,
    required this.type,
    required TextEditingController nameGiftController,
    required TextEditingController descriptionGiftController,
    required TextEditingController imageUrlGiftController,
    required TextEditingController animationUrlGiftController,
    required TextEditingController giftTypeGiftController,
    required TextEditingController rarityIdGiftController,
    required TextEditingController costPointsGiftController,
    required TextEditingController nameCityController,
    required TextEditingController textIcebreakerController,
    required TextEditingController titleInterestController,
    required TextEditingController titlePurposeController,
    required TextEditingController packIdStickerController,
    required TextEditingController emojiStickerController,
    required TextEditingController imageUrlStickerController,
    required TextEditingController titleStickerPackController,
  }) : _titlePurposeController = titlePurposeController,
       _titleStickerPackController = titleStickerPackController,
       _imageUrlStickerController = imageUrlStickerController,
       _emojiStickerController = emojiStickerController,
       _packIdStickerController = packIdStickerController,
       _titleInterestController = titleInterestController,
       _textIcebreakerController = textIcebreakerController,
       _nameCityController = nameCityController,
       _costPointsGiftController = costPointsGiftController,
       _rarityIdGiftController = rarityIdGiftController,
       _giftTypeGiftController = giftTypeGiftController,
       _animationUrlGiftController = animationUrlGiftController,
       _imageUrlGiftController = imageUrlGiftController,
       _descriptionGiftController = descriptionGiftController,
       _nameGiftController = nameGiftController;
  final ContentType type;
  final TextEditingController _nameGiftController;
  final TextEditingController _descriptionGiftController;
  final TextEditingController _imageUrlGiftController;
  final TextEditingController _animationUrlGiftController;
  final TextEditingController _giftTypeGiftController;
  final TextEditingController _rarityIdGiftController;
  final TextEditingController _costPointsGiftController;

  final TextEditingController _nameCityController;

  final TextEditingController _textIcebreakerController;

  final TextEditingController _titleInterestController;

  final TextEditingController _titlePurposeController;

  final TextEditingController _packIdStickerController;
  final TextEditingController _emojiStickerController;
  final TextEditingController _imageUrlStickerController;

  final TextEditingController _titleStickerPackController;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ContentType.cities:
        return CityForm(cityName: _nameCityController);
      case ContentType.icebreakers:
        return IcebreakerForm(textIcebreaker: _textIcebreakerController);
      case ContentType.interests:
        return InterestForm(titleInterest: _titleInterestController);
      case ContentType.purposes:
        return PurposeForm(titlePurpose: _titlePurposeController);
      case ContentType.stickerPacks:
        return StickerPackForm(titleStickerPack: _titleStickerPackController);
      case ContentType.stickers:
        return StickerForm(
          packIdSticker: _packIdStickerController,
          emojiSticker: _emojiStickerController,
          imageUrlSticker: _imageUrlStickerController,
        );
      case ContentType.games:
        return const Text('Форма создания игры');
      case ContentType.gifts:
        return GiftForm(
          nameGift: _nameGiftController,
          descriptionGift: _descriptionGiftController,
          imageUrlGift: _imageUrlGiftController,
          animationUrlGift: _animationUrlGiftController,
          giftTypeGift: _giftTypeGiftController,
          rarityIdGift: _rarityIdGiftController,
          costPointsGift: _costPointsGiftController,
        );
    }
  }
}
