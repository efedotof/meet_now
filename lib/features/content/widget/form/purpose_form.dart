import 'package:flutter/material.dart';

class PurposeForm extends StatelessWidget {
  const PurposeForm({super.key, required this.titlePurpose});
  final TextEditingController titlePurpose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: titlePurpose,
          decoration: const InputDecoration(
            labelText: 'Название цели',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
