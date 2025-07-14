import 'package:flutter/material.dart';

class TemporaryChatsBanner extends StatelessWidget {
  final int count;

  const TemporaryChatsBanner({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: theme.cardTheme.shape,
      color: theme.cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.timer, color: theme.iconTheme.color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'У вас $count временных чатов',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Посмотреть')),
          ],
        ),
      ),
    );
  }
}
