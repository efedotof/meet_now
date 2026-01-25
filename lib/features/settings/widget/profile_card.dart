import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            style: Theme.of(context).textTheme.titleLarge,
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
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.people,
                      //       size: 16,
                      //       color: Theme.of(context).iconTheme.color,
                      //     ),
                      //     // const SizedBox(width: 4),
                      //     // Text(
                      //     //   S
                      //     //       .of(context)
                      //     //       .friendsCount(user.friends?.length ?? 0),
                      //     //   style: Theme.of(context).textTheme.bodySmall,
                      //     // ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed:
                      () => context.pushRoute(SettingProfileRoute(user: user)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
