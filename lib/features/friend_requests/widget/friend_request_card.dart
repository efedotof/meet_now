import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friend_requests/cubit/friend_cubit.dart';
import 'package:meet_now_app_server/model/friends_request/friend_request.dart';

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
              backgroundImage:
                  friendRequest.avatar != null
                      ? NetworkImage(friendRequest.avatar!)
                      : null,
              child:
                  friendRequest.avatar == null
                      ? const Icon(Icons.person)
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
                          '${friendRequest.age} лет',
                        friendRequest.city,
                      ].where((e) => e != null).join(', '),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed:
                      () => context.read<FriendCubit>().acceptRequest(
                        friendRequest.id,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed:
                      () => context.read<FriendCubit>().rejectRequest(
                        friendRequest.id,
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
