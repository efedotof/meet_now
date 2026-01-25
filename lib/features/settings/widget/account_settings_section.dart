import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

import 'settings_card.dart';
import 'settings_item.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).accountSettings,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        SettingsCard(
          items: [
            SettingsItem(
              icon: Icons.person,
              title: S.of(context).profile,
              onTap: () => context.pushRoute(ProfileRoute()),
            ),
            SettingsItem(
              icon: Icons.group_add,
              title: S.of(context).friendRequests,
              onTap: () => context.pushRoute(const FriendRequestsRoute()),
            ),
            SettingsItem(
              icon: Icons.people,
              title: S.of(context).friends,
              onTap: () => context.pushRoute(const FriendsRoute()),
            ),
            SettingsItem(
              icon: Icons.report_problem,
              title: S.of(context).my_complaints,
              onTap: () => context.pushRoute(const MyReportRoute()),
            ),

            // SettingsItem(
            //   icon: Icons.qr_code,
            //   title: S.of(context).qrScanner,
            //   onTap: () => context.pushRoute(const QrCodeRoute()),
            // ),
          ],
        ),
      ],
    );
  }
}
