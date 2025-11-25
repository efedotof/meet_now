import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

class FriendsSection extends StatelessWidget {
  const FriendsSection({super.key, required this.theme, required this.user});
  final ThemeData theme;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).friends, style: theme.textTheme.titleLarge),
                TextButton(
                  onPressed: () => context.replaceRoute(FriendsRoute()),
                  child: Text(S.of(context).viewAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (user.friends != null && user.friends!.isNotEmpty)
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: user.friends!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[800],
                            child: const Icon(Icons.person),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${S.of(context).friend} ${index + 1}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              Text(
                S.of(context).noFriendsYet,
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
