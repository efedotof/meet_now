import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/social/user_activity/user_activity.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.chatModel,
    required this.userId,
    required this.onBackPressed,
    required this.isTemporary,
    this.timerText,
    this.onClearHistory,
    this.onDeleteChat,
    this.onBlockUser,
    this.onReportUser,
    this.onContinueChat,
    this.onRequestFriend,
  });

  final PermanentChatResponseDto? chatModel;
  final String userId;
  final VoidCallback onBackPressed;
  final bool isTemporary;
  final String? timerText;
  final VoidCallback? onRequestFriend;
  final VoidCallback? onClearHistory;
  final VoidCallback? onDeleteChat;
  final VoidCallback? onBlockUser;
  final VoidCallback? onReportUser;
  final VoidCallback? onContinueChat;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  String _getOtherUserName() {
    if (widget.chatModel == null) {
      return S.of(context).anonymousUser;
    }

    if (widget.userId == widget.chatModel!.user1Id) {
      return "${widget.chatModel!.user2Firstname} ${widget.chatModel!.user2Subname}";
    } else {
      return "${widget.chatModel!.user1Firstname} ${widget.chatModel!.user1Subname}";
    }
  }

  String _getOtherUserId() {
    if (widget.chatModel == null) {
      return S.of(context).anonymousUser;
    }

    if (widget.userId == widget.chatModel!.user1Id) {
      return widget.chatModel!.user2Id;
    } else {
      return widget.chatModel!.user1Id;
    }
  }

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'friend_request',
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Добавить в друзья',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
        if (widget.isTemporary && widget.onContinueChat != null)
          PopupMenuItem<String>(
            value: 'continue_chat',
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Продолжить чат',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        PopupMenuItem<String>(
          value: 'clear_history',
          child: Row(
            children: [
              Icon(
                Icons.cleaning_services_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(S.of(context).clearHistory),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete_chat',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                S.of(context).deletechat,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'block_user',
          child: Row(
            children: [
              Icon(Icons.block, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 12),
              Text(
                S.of(context).blockuser,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'report_user',
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                S.of(context).reportuser,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuAction(value);
      }
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case "friend_request":
        _showFriendRequest();
        break;
      case 'continue_chat':
        widget.onContinueChat?.call();
        break;
      case 'clear_history':
        _showClearHistoryConfirmation();
        break;
      case 'delete_chat':
        _showDeleteChatConfirmation();
        break;
      case 'block_user':
        _showBlockUserConfirmation();
        break;
      case 'report_user':
        _showReportUserDialog();
        break;
    }
  }

  void _showFriendRequest() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Хотите добавить пользователя в друзья ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // widget.onClearHistory?.call();
                  context.read<ChatMessageCubit>().friendRequest(
                    context: context,
                    toUserId: _getOtherUserId(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).historycleared),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
                child: Text(S.of(context).clear),
              ),
            ],
          ),
    );
  }

  void _showClearHistoryConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).clearHistory),
            content: Text(S.of(context).clearhistoryconfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onClearHistory?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).historycleared),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
                child: Text(S.of(context).clear),
              ),
            ],
          ),
    );
  }

  void _showDeleteChatConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).deletechat),
            content: Text(S.of(context).deletechatconfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDeleteChat?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).chatdeleted),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                },
                child: Text(S.of(context).delete),
              ),
            ],
          ),
    );
  }

  void _showBlockUserConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).blockuser),
            content: Text(S.of(context).blockuserconfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onBlockUser?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).userblocked),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                },
                child: Text(S.of(context).block),
              ),
            ],
          ),
    );
  }

  void _showReportUserDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).reportuser),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).reportuserdescription),
                const SizedBox(height: 16),
                Text(
                  S.of(context).selectreason,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ..._getReportReasons().map(
                  (reason) =>
                      RadioListTile<String>(title: Text(reason), value: reason),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: S.of(context).additionalcomments,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onReportUser?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).reportsubmitted),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
                child: Text(S.of(context).submitreport),
              ),
            ],
          ),
    );
  }

  List<String> _getReportReasons() {
    return [
      S.of(context).spam,
      S.of(context).harassment,
      S.of(context).inappropriatecontent,
      S.of(context).fakeprofile,
      S.of(context).other,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<UserActivityCubit, UserActivityState>(
      builder: (context, activityState) {
        final isOnline = activityState.maybeWhen(
          activity: (activity) => activity.activityType == ActivityType.ONLINE,
          orElse: () => false,
        );

        return AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 1,
          scrolledUnderElevation: 4,
          shadowColor: theme.colorScheme.shadow,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: widget.onBackPressed,
          ),
          title: Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isOnline
                                ? Colors.green
                                : theme.colorScheme.outlineVariant,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.person, size: 24),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getOtherUserName(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: activityState.when(
                        initial: () {
                          if (!widget.isTemporary) {
                            return const SizedBox();
                          }
                          return Text(
                            S.of(context).connecting,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                        activity: (UserActivity activity) {
                          if (activity.userId == widget.userId) {
                            return const SizedBox();
                          }

                          final statusText = switch (activity.activityType) {
                            ActivityType.TYPING => S.of(context).typing,
                            ActivityType.OFFLINE => S.of(context).offline,
                            ActivityType.SENDING_FILE =>
                              S.of(context).sendingFile,
                            ActivityType.SENDING_IMAGE =>
                              S.of(context).sendingImage,
                            ActivityType.ONLINE => S.of(context).online,
                          };

                          return Text(
                            statusText,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color:
                                  activity.activityType == ActivityType.ONLINE
                                      ? Colors.green
                                      : theme.colorScheme.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (widget.chatModel != null || widget.isTemporary)
              IconButton(
                icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
                onPressed: () => _showMenu(context),
              ),
            if (widget.isTemporary && widget.timerText != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      maxWidth: 70,
                    ),
                    child: Text(
                      widget.timerText!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
