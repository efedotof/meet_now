import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/settings/widget/widget.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<SettingsCubit>().userModelAppInterface.user!;
    return Scaffold(
      appBar: AppBar(title: const Text("Настройки"), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage:
                            user.avatar != null
                                ? NetworkImage(user.avatar!)
                                : null,
                        child:
                            user.avatar == null
                                ? const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.firstname} ${user.subname}',
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${user.username}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${user.friends?.length ?? 0} друзей',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed:
                            () => context.pushRoute(
                              SettingProfileRoute(user: user),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Настройки аккаунта',
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
                        title: 'Профиль',
                        onTap: () => context.pushRoute(ProfileRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.group_add,
                        title: 'Мои заявки',
                        onTap: () => context.pushRoute(FriendRequestsRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.language,
                        title: 'Язык',
                        trailing: Text(
                          'Русский',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () => context.pushRoute(LanguageRoute()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Настройки приложения',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SettingsCard(
                    items: [
                      SettingsItem(
                        icon: Icons.notifications,
                        title: 'Уведомления',
                        onTap:
                            () => context.pushRoute(NotificationSettingRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.security,
                        title: 'Безопасность',
                        onTap: () => context.pushRoute(SecurityRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.brightness_6,
                        title: 'Тема',
                        onTap: () => context.pushRoute(ThemeRoute()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'О приложении',
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
                        title: 'О приложении',
                        onTap: () => context.pushRoute(AboutAppRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.support_agent,
                        title: 'Поддержка',
                        onTap: () => context.pushRoute(SupportRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.exit_to_app,
                        title: 'Выйти',
                        titleColor: Colors.red,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Версия 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
