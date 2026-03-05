import 'package:flutter/material.dart';
import 'package:meet_now_app/features/security/widget/backspace_button.dart';
import 'package:meet_now_app/features/security/widget/my_button.dart';

class NumPad extends StatelessWidget {
  final void Function(String) onKeyPressed;
  final VoidCallback onBackspacePressed;
  final bool isMobile;

  const NumPad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspacePressed,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: isMobile ? 1.5 : 1.8,
      mainAxisSpacing: isMobile ? 8 : 12,
      crossAxisSpacing: isMobile ? 8 : 12,
      children: [
        MyButton(value: '1', onKeyPressed: onKeyPressed),
        MyButton(value: '2', onKeyPressed: onKeyPressed),
        MyButton(value: '3', onKeyPressed: onKeyPressed),
        MyButton(value: '4', onKeyPressed: onKeyPressed),
        MyButton(value: '5', onKeyPressed: onKeyPressed),
        MyButton(value: '6', onKeyPressed: onKeyPressed),
        MyButton(value: '7', onKeyPressed: onKeyPressed),
        MyButton(value: '8', onKeyPressed: onKeyPressed),
        MyButton(value: '9', onKeyPressed: onKeyPressed),
        const SizedBox.shrink(),
        MyButton(value: '0', onKeyPressed: onKeyPressed),
        BackspaceButton(onBackspacePressed: onBackspacePressed),
      ],
    );
  }
}
