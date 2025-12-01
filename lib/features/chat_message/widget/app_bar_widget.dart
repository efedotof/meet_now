import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/social/user_activity/user_activity.dart';

class AppBarWidget extends StatefulWidget {
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
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final GlobalKey _menuKey = GlobalKey();

  String _getOtherUserName() {
    if (widget.chatModel == null) return S.of(context).anonymousUser;

    if (widget.userId == widget.chatModel!.user1Id) {
      return "${widget.chatModel!.user2Firstname} ${widget.chatModel!.user2Subname}";
    } else {
      return "${widget.chatModel!.user1Firstname} ${widget.chatModel!.user1Subname}";
    }
  }

  void _showMenu() {
    final RenderBox button =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
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

    final theme = Theme.of(context);
    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.dialogBackgroundColor,
      items: [
        if (widget.chatModel != null)
          PopupMenuItem<String>(
            value: 'friend_request',
            child: Row(
              children: [
                Icon(Icons.person_add, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Добавить в друзья',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        if (widget.isTemporary && widget.onContinueChat != null)
          PopupMenuItem<String>(
            value: 'continue_chat',
            child: Row(
              children: [
                Icon(Icons.access_time, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Продолжить чат',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        if (widget.onClearHistory != null)
          PopupMenuItem<String>(
            value: 'clear_history',
            child: Row(
              children: [
                Icon(
                  Icons.cleaning_services_outlined,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text(
                  S.of(context).clearHistory,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
        if (widget.onDeleteChat != null)
          PopupMenuItem<String>(
            value: 'delete_chat',
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: theme.colorScheme.error),
                const SizedBox(width: 12),
                Text(
                  S.of(context).deletechat,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
        if (widget.onBlockUser != null)
          PopupMenuItem<String>(
            value: 'block_user',
            child: Row(
              children: [
                Icon(Icons.block, color: theme.colorScheme.error),
                const SizedBox(width: 12),
                Text(
                  S.of(context).blockuser,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
        if (widget.onReportUser != null)
          PopupMenuItem<String>(
            value: 'report_user',
            child: Row(
              children: [
                Icon(Icons.flag_outlined, color: theme.colorScheme.error),
                const SizedBox(width: 12),
                Text(
                  S.of(context).reportuser,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value != null) _handleMenuAction(value);
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Добавить в друзья?"),
            content: Text(
              "Хотите отправить заявку в друзья пользователю ${_getOtherUserName()}?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onRequestFriend?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Заявка в друзья отправлена"),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                },
                child: const Text("Отправить"),
              ),
            ],
          ),
    );
  }

  void _showClearHistoryConfirmation() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(S.of(context).clearHistory),
            content: Text(S.of(context).clearhistoryconfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onClearHistory?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).historycleared),
                      backgroundColor: theme.colorScheme.primary,
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(S.of(context).deletechat),
            content: Text(S.of(context).deletechatconfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onDeleteChat?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).chatdeleted),
                      backgroundColor: theme.colorScheme.error,
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(S.of(context).blockuser),
            content: Text(S.of(context).blockuserconfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onBlockUser?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).userblocked),
                      backgroundColor: theme.colorScheme.error,
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
    String? selectedReason;
    final commentController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(S.of(context).reportuser),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).reportuserdescription),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).selectreason,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ..._getReportReasons().map(
                          (reason) => RadioListTile<String>(
                            title: Text(reason),
                            value: reason,
                            groupValue: selectedReason,
                            onChanged:
                                (value) =>
                                    setState(() => selectedReason = value),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            labelText: S.of(context).additionalcomments,
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(S.of(context).cancel),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
                      onPressed: () {
                        if (selectedReason == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Пожалуйста, выберите причину жалобы",
                              ),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                          return;
                        }
                        Navigator.pop(context);
                        widget.onReportUser?.call();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).reportsubmitted),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                      },
                      child: Text(S.of(context).submitreport),
                    ),
                  ],
                ),
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
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<UserActivityCubit, UserActivityState>(
      builder: (context, state) {
        final isOnline = state.maybeWhen(
          activity: (activity) => activity.activityType == ActivityType.ONLINE,
          orElse: () => false,
        );

        return Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.black87 : Colors.white70,
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: widget.onBackPressed,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isDark ? Colors.black87 : Colors.white70,
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 45,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                isDark ? Colors.white : Colors.black,
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
                                    width: 2,
                                    color: theme.colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getOtherUserName(),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.isTemporary) _buildStatusText(state, theme),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Container(
                key: _menuKey,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.black87 : Colors.white70,
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child:
                    widget.isTemporary && widget.timerText != null
                        ? Text(
                          widget.timerText!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error,
                          ),
                        )
                        : (widget.chatModel != null || widget.isTemporary)
                        ? GestureDetector(
                          onTap: _showMenu,
                          child: Icon(
                            Icons.more_vert,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        )
                        : const SizedBox(width: 40),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusText(UserActivityState state, ThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: state.when(
        initial: () {
          return Text(
            S.of(context).connecting,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
        activity: (UserActivity activity) {
          if (activity.userId == widget.userId) return const SizedBox();

          final statusText = switch (activity.activityType) {
            ActivityType.TYPING => S.of(context).typing,
            ActivityType.OFFLINE => S.of(context).offline,
            ActivityType.SENDING_FILE => S.of(context).sendingFile,
            ActivityType.SENDING_IMAGE => S.of(context).sendingImage,
            ActivityType.ONLINE => S.of(context).online,
          };

          final statusColor =
              activity.activityType == ActivityType.ONLINE
                  ? Colors.green
                  : theme.colorScheme.onPrimaryContainer;

          return Text(
            statusText,
            style: theme.textTheme.labelSmall?.copyWith(color: statusColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
}
