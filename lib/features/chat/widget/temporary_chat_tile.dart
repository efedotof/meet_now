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
        leading: _buildAvatar(context),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (unreadCount > 0) ...[
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
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              lastMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        trailing: _buildTemporaryIndicator(),
        onTap: () {
          context.pushRoute(ChatMessageRoute(temporaryChatModel: chat));
        },
        onLongPress: () {
          _showDeleteDialog(context);
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[300],
          backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
          child:
              avatar == null
                  ? const Icon(Icons.person, color: Colors.grey, size: 24)
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
            child: const Icon(Icons.access_time, color: Colors.white, size: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildTemporaryIndicator() {
    // Если чат завершен, не показываем индикатор
    if (chat.isFinished) {
      return const SizedBox();
    }

    String timeText;

    // Если есть данные из cubit, используем их
    if (remainingTime != null && remainingTime! > 0) {
      if (remainingTime! > 86400) {
        // больше суток
        timeText = '${(remainingTime! / 86400).floor()}д';
      } else if (remainingTime! > 3600) {
        // больше часа
        timeText = '${(remainingTime! / 3600).floor()}ч';
      } else if (remainingTime! > 60) {
        // больше минуты
        timeText = '${(remainingTime! / 60).floor()}м';
      } else {
        timeText = 'скоро';
      }
    } else {
      // Если данных из cubit нет, рассчитываем из createdAt и durationMinutes
      final expiresAt = chat.createdAt.add(
        Duration(minutes: chat.durationMinutes),
      );
      final now = DateTime.now();
      final difference = expiresAt.difference(now);

      if (difference.inDays > 0) {
        timeText = '${difference.inDays}д';
      } else if (difference.inHours > 0) {
        timeText = '${difference.inHours}ч';
      } else if (difference.inMinutes > 0) {
        timeText = '${difference.inMinutes}м';
      } else {
        timeText = 'скоро';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(25), // 0.1 * 255 ≈ 25
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange.withAlpha(76),
          width: 1,
        ), // 0.3 * 255 ≈ 76
      ),
      child: Text(
        timeText,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Удалить чат'),
            content: const Text(
              'Вы уверены, что хотите удалить этот временный чат?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteChat(context);
                },
                child: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _deleteChat(BuildContext context) {
    context.read<ChatCubit>().deleteTemporaryChat(chat.tempChatId, false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Временный чат удален'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
