import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final Color? textColor;

  const SectionTitle({super.key, required this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextColor = textColor ?? _getTextColor(theme);

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: effectiveTextColor,
        letterSpacing: 0.3,
      ),
      child: Text(text),
    );
  }

  Color _getTextColor(ThemeData theme) {
    return theme.brightness == Brightness.dark
        ? Colors.black87
        : Colors.white70;
  }
}
