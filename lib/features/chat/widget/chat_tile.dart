import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';
import 'chat_swipe_item.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    this.unreadCount,
    this.avatar,
    this.sendLastMessageAt,
    this.chat,
    this.temporaryChat,
  });

  final String name;
  final String lastMessage;
  final int? unreadCount;
  final String? avatar;
  final DateTime? sendLastMessageAt;
  final PermanentChatResponseDto? chat;
  final TemporaryChat? temporaryChat;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool _isDeleting = false;
  bool _imageError = false;

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).delete_a_chat),
          content: Text(S.of(context).select_the_deletion_option),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteChat(forBoth: false);
              },
              child: Text(S.of(context).just_for_me),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showConfirmDeleteForBothDialog();
              },
              child: Text(
                S.of(context).for_both,
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDeleteForBothDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).delete_for_both),
          content: Text(
            S
                .of(context)
                .this_action_cannot_be_undone_the_chat_will_be_deleted_for_all_participants,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteChat(forBoth: true);
              },
              child: Text(
                S.of(context).delete,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChat({required bool forBoth}) async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);

    try {
      final cubit = context.read<ChatCubit>();

      if (widget.chat != null) {
        await cubit.deletePermanentChat(widget.chat!.chatId, forBoth);
      } else if (widget.temporaryChat != null) {
        await cubit.deleteTemporaryChat(
          widget.temporaryChat!.tempChatId,
          forBoth,
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ChatSwipeItem(
        actionButtons: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RawMaterialButton(
              onPressed: () {},
              elevation: 2,
              shape: const CircleBorder(),
              fillColor: Colors.grey,
              constraints: const BoxConstraints(minWidth: 0),
              child: const Icon(
                Icons.notifications_off_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            RawMaterialButton(
              onPressed: _showDeleteDialog,
              elevation: 2,
              shape: const CircleBorder(),
              fillColor: Colors.red,
              constraints: const BoxConstraints(minWidth: 0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
        child: GestureDetector(
          onLongPress: _showDeleteDialog,
          child: SizedBox(
            height: 80,
            child: Stack(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap:
                      _isDeleting
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
                        if (widget.avatar == null || _imageError)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isDark ? Colors.grey[800] : Colors.grey[300],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 24,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          )
                        else
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child:
                                  _imageError
                                      ? const Icon(Icons.person)
                                      : CachedNetworkImage(
                                        imageUrl: widget.avatar!,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        errorWidget: (context, url, error) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                if (mounted) {
                                                  setState(
                                                    () => _imageError = true,
                                                  );
                                                }
                                              });
                                          return const Icon(Icons.person);
                                        },
                                      ),
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
                if (_isDeleting)
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
      ),
    );
  }
}
