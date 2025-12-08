import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/features/settings/widget/settings_card.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

import 'settings_item.dart';

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({super.key});

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).appSettings,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        SettingsCard(
          items: [
            SettingsItem(
              icon: Icons.language,
              title: S.of(context).language,
              trailing: BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) {
                  return state.when(
                    initial:
                        () => Text(
                          S.of(context).russian,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    loaded:
                        (currentLocale, supportedLocales) => Text(
                          _getLanguageName(currentLocale),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    error:
                        (message) => Text(
                          S.of(context).russian,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                  );
                },
              ),
              onTap: () => context.pushRoute(const LanguageRoute()),
            ),
            SettingsItem(
              icon: Icons.notifications,
              title: S.of(context).notifications,
              onTap: () => context.pushRoute(const NotificationRoute()),
            ),
            SettingsItem(
              icon: Icons.security,
              title: S.of(context).security,
              onTap: () => context.pushRoute(const SecurityRoute()),
            ),
            SettingsItem(
              icon: Icons.brightness_6,
              title: S.of(context).theme,
              onTap: () => context.pushRoute(const ThemeRoute()),
            ),
          ],
        ),
      ],
    );
  }
}
