import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friend_requests/cubit/friend_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/friends_request/friend_request.dart';

class FriendRequestCard extends StatelessWidget {
  final FriendRequest friendRequest;

  const FriendRequestCard({super.key, required this.friendRequest});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage:
                  friendRequest.avatar != null
                      ? NetworkImage(friendRequest.avatar!)
                      : null,
              child:
                  friendRequest.avatar == null
                      ? Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friendRequest.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (friendRequest.age != null || friendRequest.city != null)
                    Text(
                      [
                        if (friendRequest.age != null)
                          '${friendRequest.age} ${S.of(context).years}',
                        friendRequest.city,
                      ].where((e) => e != null).join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(70),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed:
                        () => context.read<FriendCubit>().acceptRequest(
                          friendRequest.id,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed:
                        () => context.read<FriendCubit>().rejectRequest(
                          friendRequest.id,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
