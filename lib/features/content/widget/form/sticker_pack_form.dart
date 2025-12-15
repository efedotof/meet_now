import 'package:flutter/material.dart';

class StickerPackForm extends StatelessWidget {
  const StickerPackForm({super.key, required this.titleStickerPack});
  final TextEditingController titleStickerPack;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: titleStickerPack,
          decoration: const InputDecoration(
            labelText: 'Название набора',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
