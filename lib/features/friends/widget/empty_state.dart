import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: 80,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 24),
          Text('У вас пока нет друзей', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(
            'Начните общаться, чтобы добавить людей в друзья',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Навигация к поиску или чатам
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text('Начать общение'),
          ),
        ],
      ),
    );
  }
}
