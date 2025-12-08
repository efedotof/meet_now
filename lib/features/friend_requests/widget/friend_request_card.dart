import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/features.dart';
import 'package:meet_now_app/features/friend_requests/cubit/friend_cubit.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/friends_request/friend_request.dart';
import 'custom_button.dart';

class FriendRequestCard extends StatelessWidget {
  final FriendRequest friendRequest;

  const FriendRequestCard({super.key, required this.friendRequest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black54,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.92,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ProfileScreen(friendRequest: friendRequest),
                ),
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              UserAvatar(radius: 24, avatarKey: friendRequest.avatar),
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
                  CustomButton(
                    onTap:
                        () => context.read<FriendCubit>().acceptRequest(
                          friendRequest.id,
                        ),
                    color: Colors.green,
                    icon: Icons.check,
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    onTap:
                        () => context.read<FriendCubit>().rejectRequest(
                          friendRequest.id,
                        ),
                    color: Colors.red,
                    icon: Icons.close,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
