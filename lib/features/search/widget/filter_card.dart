import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? cardColor;

  const FilterCard({
    super.key,
    required this.child,
    this.padding,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveCardColor = cardColor ?? _getCardColor(theme);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: effectiveCardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: effectiveCardColor.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }

  Color _getCardColor(ThemeData theme) {
    return theme.brightness == Brightness.dark
        ? Colors.white70
        : Colors.black87;
  }
}
