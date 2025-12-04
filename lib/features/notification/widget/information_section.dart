import 'package:flutter/material.dart';

class InformationSection extends StatelessWidget {
  const InformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Настройки сохраняются автоматически и применяются к новым уведомлениям.',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
