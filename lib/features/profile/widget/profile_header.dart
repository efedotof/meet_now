import 'package:flutter/material.dart';
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
                    user.avatar != null ? NetworkImage(user.avatar!) : null,
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
                '${user.age != null ? '${user.age} лет' : ''} ${user.city ?? ''}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}
