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
  bool _imageError = false;

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

  Widget _buildAvatar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[800] : Colors.grey[300];
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    if (widget.avatar == null || _imageError) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(Icons.person, size: 24, color: iconColor),
      );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          widget.avatar!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_imageError) {
                setState(() {
                  _imageError = true;
                });
              }
            });
            return Icon(Icons.person, size: 24, color: iconColor);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                strokeWidth: 2,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      confirmDismiss: (direction) async {
        _showDeleteDialog();
        return false;
      },
      child: GestureDetector(
        onLongPress: _showDeleteDialog,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(30)),
          ),
          child: Stack(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildAvatar(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.lastMessage,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  150,
                                ),
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
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                          if (widget.unreadCount != null &&
                              widget.unreadCount! > 0)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.unreadCount! > 99
                                    ? '99+'
                                    : widget.unreadCount!.toString(),
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
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
