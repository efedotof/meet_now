import 'package:flutter/material.dart';

class InterestForm extends StatelessWidget {
  const InterestForm({super.key, required TextEditingController titleInterest})
    : _titleInterest = titleInterest;

  final TextEditingController _titleInterest;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _titleInterest,
          decoration: const InputDecoration(
            labelText: 'Название интереса',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
