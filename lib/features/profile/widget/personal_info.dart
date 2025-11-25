import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key, required this.theme, required this.user});
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
            Row(
              children: [
                Icon(Icons.email, color: theme.iconTheme.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(user.email, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
            if (user.description != null) ...[
              const Divider(height: 32),
              Text(S.of(context).aboutMe, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(user.description!, style: theme.textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }
}
