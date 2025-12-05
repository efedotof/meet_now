import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

import 'stat_widget.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // StatWidget(
            //   icon: Icons.people,
            //   count: user.friends?.length ?? 0,
            //   label: "Друзья",
            // ),
            StatWidget(
              icon: Icons.favorite,
              count: user.purposes.length,
              label: S.of(context).goals,
            ),
            StatWidget(
              icon: Icons.star,
              count: user.interests.length,
              label: S.of(context).interests,
            ),
            if (user.images != null)
              StatWidget(
                icon: Icons.photo_library,
                count: user.images!.length,
                label: S.of(context).photo,
              ),
          ],
        ),
      ),
    );
  }
}
