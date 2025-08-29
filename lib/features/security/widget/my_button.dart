import 'package:flutter/material.dart';
import 'package:meet_now_app/features/security/widget/num_pad.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.value, required this.onKeyPressed});
  final String value;
  final NumPadCallback onKeyPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onKeyPressed(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withAlpha(5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
