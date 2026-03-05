import 'package:flutter/material.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});
  final User user;

  String getGender(BuildContext context, String floor) {
    if (floor == "male") {
      return S.of(context).male;
    } else {
      return S.of(context).female;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              message: S.of(context).confirmed,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Image.asset(
                                  'assets/verify.png',
                                  width: 20,
                                  height: 20,
                                  filterQuality: FilterQuality.none,
                                ),
                              ),
                            ),
                          if (user.roles.contains("ADMIN"))
                            Tooltip(
                              message: S.of(context).administrator,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Image.asset(
                                  'assets/administration.png',
                                  width: 20,
                                  height: 20,
                                  filterQuality: FilterQuality.none,
                                ),
                              ),
                            ),
                          if (user.roles.contains("MODERATION"))
                            Tooltip(
                              message: S.of(context).moderator,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Image.asset(
                                  'assets/moderator.png',
                                  width: 20,
                                  height: 20,
                                  filterQuality: FilterQuality.none,
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
                const SizedBox(height: 4),
                if (user.floor != '')
                  Text(
                    '${S.of(context).gender}: ${getGender(context, user.floor)}',
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
