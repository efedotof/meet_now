import 'package:flutter/material.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    this.unreadCount,
    required this.avatar,
    this.sendLastMessageAt,
    this.chat,
    this.temporaryChat,
    this.onTap,
    this.isSelected = false,
  });

  final String name;
  final String lastMessage;
  final int? unreadCount;
  final String avatar;
  final DateTime? sendLastMessageAt;
  final PermanentChatResponseDto? chat;
  final TemporaryChat? temporaryChat;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool isDeleting = false;

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (d == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (d == today.subtract(const Duration(days: 1))) {
      return S.of(context).yesterday;
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border:
            widget.isSelected
                ? Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                )
                : null,
      ),
      child: GestureDetector(
        child: SizedBox(
          height: 80,
          child: Stack(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: widget.onTap,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      widget.avatar.isNotEmpty
                          ? UserAvatar(avatarKey: widget.avatar, radius: 32)
                          : CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.lastMessage,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.unreadCount! > 99
                                    ? '99+'
                                    : widget.unreadCount!.toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
              if (isDeleting)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
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
}
