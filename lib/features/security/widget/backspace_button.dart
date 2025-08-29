import 'package:flutter/material.dart';

class BackspaceButton extends StatelessWidget {
  const BackspaceButton({super.key, required this.onBackspacePressed});
  final VoidCallback onBackspacePressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBackspacePressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withAlpha(5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Icon(Icons.backspace_outlined, size: 24)),
        ),
      ),
    );
  }
}
