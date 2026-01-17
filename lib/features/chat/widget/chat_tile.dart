import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';

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
  });

  final String name;
  final String lastMessage;
  final int? unreadCount;
  final String avatar;
  final DateTime? sendLastMessageAt;
  final PermanentChatResponseDto? chat;
  final TemporaryChat? temporaryChat;

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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GestureDetector(
        child: SizedBox(
          height: 80,
          child: Stack(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:
                    isDeleting
                        ? null
                        : () {
                          if (widget.chat != null) {
                            context.read<ChatCubit>().openChat(
                              chatId: widget.chat!.chatId,
                            );
                            context.pushRoute(
                              ChatMessageRoute(
                                chatModel: widget.chat,
                                temporaryChatModel: null,
                              ),
                            );
                          } else {
                            context.read<ChatCubit>().openTempChat(
                              tempChatId: widget.temporaryChat!.tempChatId,
                            );
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
                                ).colorScheme.onSurface.withAlpha(150),
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
                              ).colorScheme.onSurface.withAlpha(150),
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
