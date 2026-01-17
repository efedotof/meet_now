import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';
import 'package:random_avatar/random_avatar.dart';

class TemporaryChatTile extends StatelessWidget {
  const TemporaryChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.unreadCount,
    required this.avatar,
    required this.chat,
    this.remainingTime,
  });

  final String name;
  final String lastMessage;
  final int unreadCount;
  final String? avatar;
  final TemporaryChat chat;
  final int? remainingTime;

  @override
  Widget build(BuildContext context) {
    String timeText = '';
    if (!chat.isFinished) {
      if (remainingTime != null && remainingTime! > 0) {
        if (remainingTime! >= 86400) {
          timeText = '${(remainingTime! / 86400).floor()}${S.of(context).day}';
        } else if (remainingTime! >= 3600) {
          timeText = '${(remainingTime! / 3600).floor()}${S.of(context).hour}';
        } else if (remainingTime! >= 60) {
          timeText = '${(remainingTime! / 60).floor()}${S.of(context).Minuttt}';
        } else {
          timeText = S.of(context).soon;
        }
      } else {
        final expiresAt = chat.createdAt.add(
          Duration(minutes: chat.durationMinutes),
        );
        final diff = expiresAt.difference(DateTime.now());

        if (diff.inDays > 0) {
          timeText = '${diff.inDays}${S.of(context).day}';
        } else if (diff.inHours > 0) {
          timeText = '${diff.inHours}${S.of(context).hour}';
        } else if (diff.inMinutes > 0) {
          timeText = '${diff.inMinutes}${S.of(context).Minuttt}';
        } else {
          timeText = S.of(context).soon;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        leading: Stack(
          children: [
            RandomAvatar(chat.tempChatId.toString(), height: 48, width: 48),

            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withAlpha(50),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.access_time,
                  size: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
              ),
            ),
          ],
        ),

        trailing:
            chat.isFinished || timeText.isEmpty
                ? const SizedBox()
                : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.orange.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    timeText,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

        onTap: () {
          context.read<ChatCubit>().openTempChat(tempChatId: chat.tempChatId);
          context.pushRoute(ChatMessageRoute(temporaryChatModel: chat));
        },

        onLongPress: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text(S.of(context).delete_a_chat),
                  content: Text(
                    S
                        .of(context)
                        .are_you_sure_you_want_to_delete_this_temporary_chat,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(S.of(context).cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<ChatCubit>().deleteTemporaryChat(
                          chat.tempChatId,
                          false,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).temporary_chat_deleted),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        S.of(context).delete,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}
