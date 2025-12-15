import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

import 'empty_users.dart';
import 'user_card.dart';

class UsersList extends StatelessWidget {
  final List<User> users;

  const UsersList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const EmptyUsers();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return UserCard(user: users[index]);
      },
    );
  }
}
