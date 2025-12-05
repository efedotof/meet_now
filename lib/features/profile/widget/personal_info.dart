import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

import 'base_card.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key, required this.theme, required this.user});
  final ThemeData theme;
  final User user;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
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
            const Divider(height: 24, thickness: 0.5),
            Text(S.of(context).about_me, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(user.description!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
