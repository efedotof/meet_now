import 'package:flutter/material.dart';

class DigitButton extends StatelessWidget {
  const DigitButton({super.key, required this.digit, this.onPressed});

  final String digit;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 75,
        height: 75,
        child:
            digit == '←'
                ? IconButton(
                  icon: const Icon(Icons.backspace),
                  onPressed: onPressed,
                  iconSize: 32,
                )
                : TextButton(
                  onPressed: digit.isEmpty ? null : onPressed,
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.grey[100],
                  ),
                  child: Text(digit, style: const TextStyle(fontSize: 24)),
                ),
      ),
    );
  }
}
