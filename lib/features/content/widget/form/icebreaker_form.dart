import 'package:flutter/material.dart';

class IcebreakerForm extends StatelessWidget {
  const IcebreakerForm({
    super.key,
    required TextEditingController textIcebreaker,
  }) : _textIcebreaker = textIcebreaker;

  final TextEditingController _textIcebreaker;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _textIcebreaker,
          decoration: const InputDecoration(
            labelText: 'Текст темы',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
