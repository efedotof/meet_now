import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/social/friend_dto/friend_dto.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key, required this.friend});
  final FriendDto friend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final chat = await context.read<ChatCubit>().createPermomentChat(
          user2id: friend.id,
        );
        if (chat != null && context.mounted) {
          context.pushRoute(
            ChatMessageRoute(
              chatModel: chat,
              temporaryChatModel: null,
              chatKey: chat.chatId,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                friend.firstname.isNotEmpty ? friend.firstname[0] : 'U',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${friend.firstname} ${friend.subname}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: friend.isOnline ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        friend.isOnline
                            ? S.of(context).online
                            : S.of(context).offline,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: friend.isOnline ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
            ),
          ],
        ),
      ),
    );
  }
}
