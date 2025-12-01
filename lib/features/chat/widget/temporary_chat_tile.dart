import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';

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
          timeText = '${(remainingTime! / 86400).floor()}д';
        } else if (remainingTime! >= 3600) {
          timeText = '${(remainingTime! / 3600).floor()}ч';
        } else if (remainingTime! >= 60) {
          timeText = '${(remainingTime! / 60).floor()}м';
        } else {
          timeText = 'скоро';
        }
      } else {
        final expiresAt = chat.createdAt.add(
          Duration(minutes: chat.durationMinutes),
        );
        final diff = expiresAt.difference(DateTime.now());

        if (diff.inDays > 0) {
          timeText = '${diff.inDays}д';
        } else if (diff.inHours > 0) {
          timeText = '${diff.inHours}ч';
        } else if (diff.inMinutes > 0) {
          timeText = '${diff.inMinutes}м';
        } else {
          timeText = 'скоро';
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
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
              child:
                  avatar == null
                      ? const Icon(Icons.person, size: 24, color: Colors.grey)
                      : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
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
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withAlpha(76),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    timeText,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

        onTap: () {
          context.pushRoute(ChatMessageRoute(temporaryChatModel: chat));
        },

        onLongPress: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Удалить чат'),
                  content: const Text(
                    'Вы уверены, что хотите удалить этот временный чат?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<ChatCubit>().deleteTemporaryChat(
                          chat.tempChatId,
                          false,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Временный чат удален'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        'Удалить',
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
