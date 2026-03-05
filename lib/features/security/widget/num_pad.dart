import 'package:flutter/material.dart';
import 'backspace_button.dart';
import 'my_button.dart';

typedef NumPadCallback = void Function(String key);

class NumPad extends StatelessWidget {
  final NumPadCallback onKeyPressed;
  final VoidCallback onBackspacePressed;

  const NumPad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
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
