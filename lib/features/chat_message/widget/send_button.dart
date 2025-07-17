import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const Icon(Icons.send), onPressed: onPressed);
  }
}
