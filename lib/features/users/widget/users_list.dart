import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

import 'user_card.dart';

class UsersList extends StatelessWidget {
  final List<User> users;

  const UsersList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text('No users found', style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: users
          .map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: UserCard(user: user),
            ),
          )
          .toList(),
    );
  }
}
