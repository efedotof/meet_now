import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

import 'settings_card.dart';
import 'settings_item.dart';

class AboutAppSection extends StatelessWidget {
  const AboutAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).aboutApp,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        SettingsCard(
          items: [
            SettingsItem(
              icon: Icons.info,
              title: S.of(context).aboutApp,
              onTap: () => context.pushRoute(const AboutAppRoute()),
            ),
            SettingsItem(
              icon: Icons.support_agent,
              title: S.of(context).support,
              onTap: () => context.pushRoute(const SupportRoute()),
            ),
            SettingsItem(
              icon: Icons.exit_to_app,
              title: S.of(context).exit,
              titleColor: Colors.red,
              onTap: () => context.read<SettingsCubit>().exit(context: context),
            ),
          ],
        ),
      ],
    );
  }
}
