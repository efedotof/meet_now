import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const StatItem({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDart = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 10, color: isDart ? Colors.black : Colors.white),
        const SizedBox(width: 6),
        Text(
          count.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDart ? Colors.black : Colors.white,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDart ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }
}
