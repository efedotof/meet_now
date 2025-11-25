import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';

class ChatTile extends StatefulWidget {
  final String name;
  final String lastMessage;
  final int? unreadCount;
  final String? avatar;
  final DateTime? sendLastMessageAt;
  final PermanentChatResponseDto? chat;
  final TemporaryChat? temporaryChat;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.unreadCount,
    this.avatar,
    this.chat,
    this.temporaryChat,
    required this.sendLastMessageAt,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool _isDeleting = false;

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить чат'),
          content: const Text('Выберите вариант удаления:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteChat(forBoth: false);
              },
              child: const Text('Только для меня'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showConfirmDeleteForBothDialog();
              },
              child: const Text(
                'Для обоих',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDeleteForBothDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить для обоих'),
          content: const Text(
            'Это действие нельзя отменить. Чат будет удален для всех участников.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteChat(forBoth: true);
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChat({required bool forBoth}) async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final chatCubit = context.read<ChatCubit>();

      if (widget.chat != null) {
        await chatCubit.deletePermanentChat(widget.chat!.chatId, forBoth);
      } else if (widget.temporaryChat != null) {
        await chatCubit.deleteTemporaryChat(
          widget.temporaryChat!.tempChatId,
          forBoth,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(
        widget.chat?.chatId ??
            widget.temporaryChat?.tempChatId ??
            UniqueKey().toString(),
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        _showDeleteDialog();
        return false;
      },
      child: GestureDetector(
        onLongPress: _showDeleteDialog,
        child: Opacity(
          opacity: _isDeleting ? 0.6 : 1.0,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: theme.cardTheme.color,
            child: Stack(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap:
                      _isDeleting
                          ? null
                          : () {
                            if (widget.chat != null) {
                              context.pushRoute(
                                ChatMessageRoute(
                                  chatModel: widget.chat,
                                  temporaryChatModel: null,
                                ),
                              );
                            } else if (widget.temporaryChat != null) {
                              context.pushRoute(
                                ChatMessageRoute(
                                  chatModel: null,
                                  temporaryChatModel: widget.temporaryChat,
                                ),
                              );
                            }
                          },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  widget.avatar != null
                                      ? NetworkImage(widget.avatar!)
                                      : null,
                              backgroundColor:
                                  isDark ? Colors.grey[800] : Colors.grey[300],
                              child:
                                  widget.avatar == null
                                      ? Icon(
                                        Icons.person,
                                        size: 28,
                                        color:
                                            isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                      )
                                      : null,
                            ),
                            if (widget.unreadCount != null &&
                                widget.unreadCount! > 0)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.cardTheme.color!,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    widget.unreadCount! > 99
                                        ? '99+'
                                        : widget.unreadCount!.toString(),
                                    style: TextStyle(
                                      color:
                                          isDark ? Colors.black : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.lastMessage,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatTime(widget.sendLastMessageAt),
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            if (widget.unreadCount != null &&
                                widget.unreadCount! > 0)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isDeleting)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Вчера';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}';
    }
  }
}
