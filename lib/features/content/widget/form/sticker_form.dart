import 'package:flutter/material.dart';

class StickerForm extends StatelessWidget {
  const StickerForm({
    super.key,
    required this.packIdSticker,
    required this.emojiSticker,
    required this.imageUrlSticker,
  });
  final TextEditingController packIdSticker;
  final TextEditingController emojiSticker;
  final TextEditingController imageUrlSticker;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: packIdSticker,
          decoration: const InputDecoration(
            labelText: 'айди пакета набора',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: emojiSticker,
          decoration: const InputDecoration(
            labelText: 'эмодзи стикера',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: imageUrlSticker,
          decoration: const InputDecoration(
            labelText: 'Ссылка на стикер',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
