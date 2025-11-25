import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/settings/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserModelAppInterface>().user!;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "${context.read<UserModelAppInterface>().user!.gamePoints} points",
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => context.pushRoute(ProfileRoute()),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        UserAvatar(avatarKey: user.avatar, radius: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${user.firstname} ${user.subname}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 4),
                                  if (user.verified)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Image.asset(
                                        'assets/verify.png',
                                        width: 16,
                                        height: 16,
                                        filterQuality: FilterQuality.none,
                                        cacheWidth: 32,
                                        cacheHeight: 32,
                                      ),
                                    ),
                                  if (user.roles.contains("ADMIN"))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Image.asset(
                                        'assets/administration.png',
                                        width: 16,
                                        height: 16,
                                        filterQuality: FilterQuality.none,
                                        cacheWidth: 32,
                                        cacheHeight: 32,
                                      ),
                                    ),
                                  if (user.roles.contains("MODERATION"))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Image.asset(
                                        'assets/moderator.png',
                                        width: 16,
                                        height: 16,
                                        filterQuality: FilterQuality.none,
                                        cacheWidth: 32,
                                        cacheHeight: 32,
                                      ),
                                    ),
                                ],
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
                                    S
                                        .of(context)
                                        .friendsCount(
                                          user.friends?.length ?? 0,
                                        ),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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
                        onTap: () => context.pushRoute(FriendRequestsRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.people,
                        title: S.of(context).friend,
                        onTap: () => context.pushRoute(FriendsRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.report_problem,
                        title: "Мои жалобы",
                        onTap: () => context.pushRoute(MyReportRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.language,
                        title: S.of(context).language,
                        trailing: Text(
                          S.of(context).russian,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () => context.pushRoute(LanguageRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.qr_code,
                        title: S.of(context).qrScanner,
                        onTap: () => context.pushRoute(QrCodeRoute()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                        icon: Icons.notifications,
                        title: S.of(context).notifications,
                        onTap:
                            () => context.pushRoute(NotificationSettingRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.security,
                        title: S.of(context).security,
                        onTap: () => context.pushRoute(SecurityRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.brightness_6,
                        title: S.of(context).theme,
                        onTap: () => context.pushRoute(ThemeRoute()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                        onTap: () => context.pushRoute(AboutAppRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.support_agent,
                        title: S.of(context).support,
                        onTap: () => context.pushRoute(SupportRoute()),
                      ),
                      SettingsItem(
                        icon: Icons.exit_to_app,
                        title: S.of(context).exit,
                        titleColor: Colors.red,
                        onTap:
                            () => context.read<SettingsCubit>().exit(
                              context: context,
                            ),
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
                  S.of(context).version('1.0.0'),
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
