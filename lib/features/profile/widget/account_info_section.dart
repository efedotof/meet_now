import 'package:flutter/material.dart';
import 'package:meet_now_app/server/model/user/user.dart';

class AccountInfoSection extends StatelessWidget {
  const AccountInfoSection({
    super.key,
    required this.theme,
    required this.user,
  });
  final ThemeData theme;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Аккаунт", style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.calendar_today,
              title: "Дата регистрации:",
              value: user.createdAt.toLocal().toString().split(' ')[0],
            ),
            _InfoRow(
              icon: Icons.circle,
              title: "Статус:",
              value: user.isOnline ? "В сети" : "Не в сети",
            ),
            if (user.floor.isNotEmpty)
              _InfoRow(icon: Icons.home, title: "Пол:", value: user.floor),
            if (user.roles.isNotEmpty)
              _InfoRow(
                icon: Icons.security,
                title: "Роли:",
                value: user.roles.join(", "),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text("$title $value", style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
