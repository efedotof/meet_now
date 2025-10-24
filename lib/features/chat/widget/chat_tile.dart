import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/temporary/temporary_chat.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final int unreadCount;
  final String? avatar;
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.cardTheme.color,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (chat != null) {
            context.pushRoute(
              ChatMessageRoute(chatModel: chat, temporaryChatModel: null),
            );
          } else if (temporaryChat != null) {
            context.pushRoute(
              ChatMessageRoute(
                chatModel: null,
                temporaryChatModel: temporaryChat,
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
                        avatar != null ? NetworkImage(avatar!) : null,
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    child:
                        avatar == null
                            ? Icon(
                              Icons.person,
                              size: 28,
                              color: isDark ? Colors.white70 : Colors.black54,
                            )
                            : null,
                  ),
                  if (unreadCount > 0)
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
                          '$unreadCount',
                          style: TextStyle(
                            color: isDark ? Colors.black : Colors.white,
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
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
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
                  Text('12:30', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  if (unreadCount > 0)
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
    );
  }
}
