import 'package:flutter/material.dart';

class PinDisplay extends StatelessWidget {
  final String pin;
  final int length;

  const PinDisplay({super.key, required this.pin, required this.length});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                index < pin.length
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withAlpha(3),
          ),
        );
      }),
    );
  }
}
