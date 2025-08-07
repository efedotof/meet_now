import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/server/model/user/user.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});
  final User user;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    user.avatar != null
                        ? NetworkImage("$uploadGetAddress${user.avatar!}")
                        : null,
                backgroundColor: Colors.grey[800],
                child:
                    user.avatar == null
                        ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white70,
                        )
                        : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.username,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (user.firstname != null || user.subname != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${user.firstname ?? ''} ${user.subname ?? ''}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (user.age != null || user.city != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${user.age != null ? '${user.age} ${S.of(context).years}' : ''} ${user.city ?? ''}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
        ],
      ),
    );
  }
}