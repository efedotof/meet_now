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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          children: [
            UserAvatar(radius: 60, avatarKey: user.avatar),
            if (user.isOnline)
              Positioned(
                right: 3,
                bottom: 3,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    S.of(context).online,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (user.firstname != null || user.subname != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${user.firstname ?? ''} ${user.subname ?? ''}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                if (user.verified)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Tooltip(
                      message: S.of(context).confirmed,
                      child: Image.asset(
                        'assets/verify.png',
                        width: 20,
                        height: 20,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  ),
                if (user.roles.contains("ADMIN"))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Tooltip(
                      message: S.of(context).administrator,
                      child: Image.asset(
                        'assets/administration.png',
                        width: 20,
                        height: 20,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  ),
                if (user.roles.contains("MODERATION"))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Tooltip(
                      message: S.of(context).moderator,
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
            if (user.age != null || user.city != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user.age != null)
                      Text(
                        '${user.age} ${S.of(context).years}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (user.age != null && user.city != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('•'),
                      ),
                    if (user.city != null)
                      Text(
                        user.city!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            if (user.floor != '')
              Text('Пол: ${getGender(context, user.floor)}'),
          ],
        ),
      ],
    );
  }
}
