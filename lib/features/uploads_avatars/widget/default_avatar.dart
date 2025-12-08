import 'package:flutter/material.dart';

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.person, size: 70, color: Colors.white),
    );
  }
}
