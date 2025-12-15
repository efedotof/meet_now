import 'package:flutter/material.dart';

class GiftForm extends StatelessWidget {
  const GiftForm({
    super.key,
    required TextEditingController nameGift,
    required TextEditingController descriptionGift,
    required TextEditingController imageUrlGift,
    required TextEditingController animationUrlGift,
    required TextEditingController giftTypeGift,
    required TextEditingController rarityIdGift,
    required TextEditingController costPointsGift,
  }) : _costPointsGift = costPointsGift,
       _rarityIdGift = rarityIdGift,
       _giftTypeGift = giftTypeGift,
       _animationUrlGift = animationUrlGift,
       _imageUrlGift = imageUrlGift,
       _descriptionGift = descriptionGift,
       _nameGift = nameGift;
  final TextEditingController _nameGift;
  final TextEditingController _descriptionGift;
  final TextEditingController _imageUrlGift;
  final TextEditingController _animationUrlGift;
  final TextEditingController _giftTypeGift;
  final TextEditingController _rarityIdGift;
  final TextEditingController _costPointsGift;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _nameGift,
          decoration: const InputDecoration(
            labelText: 'Название подарка',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: _descriptionGift,
          decoration: const InputDecoration(
            labelText: 'Описание подарка',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: _imageUrlGift,
          decoration: const InputDecoration(
            labelText: 'Ссылка на подарок',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: _animationUrlGift,
          decoration: const InputDecoration(
            labelText: 'Анимированная ссылка на подарок',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: _giftTypeGift,
          decoration: const InputDecoration(
            labelText: 'Тип подарка',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: _rarityIdGift,
          decoration: const InputDecoration(
            labelText: 'Раритет  подарка',
            border: OutlineInputBorder(),
          ),
        ),

        TextFormField(
          controller: _costPointsGift,
          decoration: const InputDecoration(
            labelText: 'Стоимость подарка',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
