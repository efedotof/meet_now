import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  const MyChip({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
