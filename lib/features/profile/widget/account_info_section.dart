import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

import 'base_card.dart';
import 'info_row.dart';

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
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).account, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.calendar_today,
            title: S.of(context).registration_date,
            value: user.createdAt.toLocal().toString().split(' ')[0],
          ),
          if (user.floor.isNotEmpty)
            InfoRow(
              icon: Icons.home,
              title: S.of(context).gender,
              value: user.floor,
            ),
          if (user.roles.isNotEmpty)
            InfoRow(
              icon: Icons.security,
              title: S.of(context).roles,
              value: user.roles.join(", "),
            ),
        ],
      ),
    );
  }
}
