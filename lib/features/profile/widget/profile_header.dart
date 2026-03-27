import 'package:flutter/material.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});
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

  String getGender(BuildContext context, String floor) {
    if (floor == "male") {
      return S.of(context).male;
    } else {
      return S.of(context).female;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleIconAsset = _getRoleIconAsset();
    final roleTooltip = _getRoleTooltipMessage(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              UserAvatar(radius: 60, avatarKey: user.avatar),
              if (user.isOnline)
                Positioned(
                  right: 3,
                  bottom: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      S.of(context).online,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          if (user.firstname != null || user.subname != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${user.firstname ?? ''} ${user.subname ?? ''}'
                                    .trim(),
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          if (user.verified)
                            Tooltip(
                              message: S.of(context).verifiedAccount,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Image.asset(
                                  'assets/verify.png',
                                  width: 20,
                                  height: 20,
                                  filterQuality: FilterQuality.none,
                                  cacheWidth: 40,
                                  cacheHeight: 40,
                                ),
                              ),
                            ),
                          if (roleIconAsset != null && roleTooltip != null)
                            Tooltip(
                              message: roleTooltip,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Image.asset(
                                  roleIconAsset,
                                  width: 20,
                                  height: 20,
                                  filterQuality: FilterQuality.none,
                                  cacheWidth: 40,
                                  cacheHeight: 40,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (user.age != null || user.city != null)
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (user.age != null)
                            Text(
                              '${user.age} ${S.of(context).years}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          if (user.age != null && user.city != null)
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
                  ),
                const SizedBox(height: 4),
                if (user.floor != '')
                  Text(
                    '${S.of(context).gender}: ${getGender(context, user.floor)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                Text(
                  user.isCardMode!
                      ? S.of(context).theModeIsActivated
                      : S.of(context).modeNotActivated,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
