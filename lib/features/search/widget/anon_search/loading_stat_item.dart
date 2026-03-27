import 'package:flutter/material.dart';

class LoadingStatItem extends StatelessWidget {
  const LoadingStatItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 10,
          decoration: BoxDecoration(
            color: colors.outline.withAlpha(10),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
