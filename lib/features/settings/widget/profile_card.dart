import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});
  final User user;

  String? _getRoleIconAsset() {
    final roles = user.roles;
    if (roles.contains("ADMIN") &&
        roles.contains("MODERATION") &&
        roles.contains("PREMIUM")) {
      return 'assets/amp.png';
    } else if (roles.contains("ADMIN") && roles.contains("MODERATION")) {
      return 'assets/am.png';
    } else if (roles.contains("ADMIN") && roles.contains("PREMIUM")) {
      return 'assets/ap.png';
    } else if (roles.contains("MODERATION") && roles.contains("PREMIUM")) {
      return 'assets/mp.png';
    } else if (roles.contains("ADMIN")) {
      return 'assets/administration.png';
    } else if (roles.contains("MODERATION")) {
      return 'assets/moderator.png';
    } else if (roles.contains("PREMIUM")) {
      return 'assets/prem.png';
    }
    return null;
  }

  String? _getRoleTooltipMessage(BuildContext context) {
    final roles = user.roles;
    if (roles.contains("ADMIN") &&
        roles.contains("MODERATION") &&
        roles.contains("PREMIUM")) {
      return S.of(context).administratorModeratorPremium;
    } else if (roles.contains("ADMIN") && roles.contains("MODERATION")) {
      return S.of(context).administratorModerator;
    } else if (roles.contains("ADMIN") && roles.contains("PREMIUM")) {
      return S.of(context).administratorPremium;
    } else if (roles.contains("MODERATION") && roles.contains("PREMIUM")) {
      return S.of(context).moderatorPremium;
    } else if (roles.contains("ADMIN")) {
      return S.of(context).administrator;
    } else if (roles.contains("MODERATION")) {
      return S.of(context).moderator;
    } else if (roles.contains("PREMIUM")) {
      return S.of(context).premium;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final roleIconAsset = _getRoleIconAsset();
    final roleTooltip = _getRoleTooltipMessage(context);

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
                          if (roleIconAsset != null && roleTooltip != null)
                            Tooltip(
                              message: roleTooltip,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 2,
                                  right: 4,
                                ),
                                child: Image.asset(
                                  roleIconAsset,
                                  width: 16,
                                  height: 16,
                                  filterQuality: FilterQuality.none,
                                  cacheWidth: 32,
                                  cacheHeight: 32,
                                ),
                              ),
                            ),
                          Text(
                            '${user.firstname} ${user.subname}',
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),

                          if (user.verified)
                            Tooltip(
                              message: S.of(context).verifiedAccount,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2, left: 4),
                                child: Image.asset(
                                  'assets/verify.png',
                                  width: 16,
                                  height: 16,
                                  filterQuality: FilterQuality.none,
                                  cacheWidth: 32,
                                  cacheHeight: 32,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 6),
                            Text(
                              '@${user.username}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (user.city != null)
                              const Text(
                                '•',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (user.city != null)
                              Text(
                                user.city!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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
