import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/features/profile/view/profile_screen.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/social/user_activity/user_activity.dart';
import 'package:random_avatar/random_avatar.dart';

import 'status_text.dart';

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
    this.onRequestFriend,
    this.tempChatId,
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
  final String? tempChatId;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget>
    with WidgetsBindingObserver {
  final GlobalKey _menuKey = GlobalKey();
  bool _isMobileLayout = false;
  static const double mobileBreakpoint = 768;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      _checkLayout();
    }
  }

  void _checkLayout() {
    final double width = MediaQuery.of(context).size.width;
    final bool newIsMobileLayout = width < mobileBreakpoint;

    if (mounted && _isMobileLayout != newIsMobileLayout) {
      setState(() {
        _isMobileLayout = newIsMobileLayout;
      });
    }
  }

  String _getOtherUserName() {
    if (widget.chatModel == null) return S.of(context).anonymousUser;

    if (widget.userId == widget.chatModel!.user1Id) {
      return "${widget.chatModel!.user2Firstname} ${widget.chatModel!.user2Subname}";
    } else {
      return "${widget.chatModel!.user1Firstname} ${widget.chatModel!.user1Subname}";
    }
  }

  String _getOtherUserId() {
    if (widget.chatModel == null) return S.of(context).anonymousUser;

    if (widget.userId == widget.chatModel!.user1Id) {
      return widget.chatModel!.user2Id;
    } else {
      return widget.chatModel!.user1Id;
    }
  }

  String _getOtherAvatar() {
    if (widget.chatModel == null) return S.of(context).anonymousUser;

    if (widget.userId == widget.chatModel!.user1Id) {
      return "${widget.chatModel!.user2Avatar}";
    } else {
      return "${widget.chatModel!.user1Avatar}";
    }
  }

  Set<String>? _getOtherRoles() {
    if (widget.chatModel == null) return null;
    if (widget.userId == widget.chatModel!.user1Id) {
      return widget.chatModel!.rolesUser2;
    } else {
      return widget.chatModel!.rolesUser1;
    }
  }

  bool? _getOtherVerified() {
    return null;
  }

  bool get _useRandomAvatar {
    if (widget.isTemporary) return true;

    final avatar = _getOtherAvatar();
    return avatar.isEmpty || avatar == S.of(context).anonymousUser;
  }

  String _getAvatarSeed() {
    if (widget.isTemporary) {
      return widget.tempChatId ?? 'temporary_${widget.userId}';
    } else {
      return _getOtherUserId();
    }
  }

  String? _getRoleIconAsset(Set<String>? roles) {
    if (roles == null) return null;
    if (roles.contains("ADMIN") &&
        roles.contains("MODERATION") &&
        roles.contains("PREMIUM")) {
      return 'assets/amp.png';
    } else if (roles.contains("ADMIN") && roles.contains("MODERATION")) {
      return 'assets/am.png';
    } else if (roles.contains("ADMIN") && roles.contains("PREMIUM")) {
      return 'assets/ap.png';
    } else if (roles.contains("MODERATION") && roles.contains("PREMIUM")) {
      return 'assets/mp.png';
    } else if (roles.contains("ADMIN")) {
      return 'assets/administration.png';
    } else if (roles.contains("MODERATION")) {
      return 'assets/moderator.png';
    } else if (roles.contains("PREMIUM")) {
      return 'assets/prem.png';
    }
    return null;
  }

  String? _getRoleTooltipMessage(Set<String>? roles) {
    if (roles == null) return null;
    if (roles.contains("ADMIN") &&
        roles.contains("MODERATION") &&
        roles.contains("PREMIUM")) {
      return S.of(context).administratorModeratorPremium;
    } else if (roles.contains("ADMIN") && roles.contains("MODERATION")) {
      return S.of(context).administratorModerator;
    } else if (roles.contains("ADMIN") && roles.contains("PREMIUM")) {
      return S.of(context).administratorPremium;
    } else if (roles.contains("MODERATION") && roles.contains("PREMIUM")) {
      return S.of(context).moderatorPremium;
    } else if (roles.contains("ADMIN")) {
      return S.of(context).administrator;
    } else if (roles.contains("MODERATION")) {
      return S.of(context).moderator;
    } else if (roles.contains("PREMIUM")) {
      return S.of(context).premium;
    }
    return null;
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
      items: [
        if (widget.chatModel != null)
          PopupMenuItem<String>(
            value: 'friend_request',
            child: Row(
              children: [
                Icon(Icons.person_add, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  S.of(context).add_to_friends,
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
        widget.onReportUser?.call();
        break;
    }
  }

  void _showFriendRequest() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(S.of(context).add_to_friends),
            content: Text(
              "${S.of(context).would_you_like_to_send_a_friend_request_to_a_user} ${_getOtherUserName()}?",
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
                      content: Text(
                        S.of(context).the_friend_request_has_been_sent,
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                },
                child: Text(S.of(context).send),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });

    bool isDesktopPlatform = false;
    if (!kIsWeb) {
      isDesktopPlatform =
          Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    }

    final bool useDesktopAppBar =
        (kIsWeb || isDesktopPlatform) && !_isMobileLayout;

    return BlocBuilder<UserActivityCubit, UserActivityState>(
      builder: (context, state) {
        final isOnline = state.maybeWhen(
          activity: (activity) => activity.activityType == ActivityType.ONLINE,
          orElse: () => false,
        );

        final double containerWidthMultiplier = useDesktopAppBar ? 0.4 : 0.6;

        final otherRoles = _getOtherRoles();
        final otherVerified = _getOtherVerified();
        final roleIconAsset = _getRoleIconAsset(otherRoles);
        final roleTooltip = _getRoleTooltipMessage(otherRoles);

        return Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!useDesktopAppBar)
                Material(
                  color: isDark ? Colors.black87 : Colors.white70,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: widget.onBackPressed,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isDark ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 6),

              widget.isTemporary
                  ? Container(
                    height: 45,
                    width:
                        MediaQuery.of(context).size.width *
                        containerWidthMultiplier,
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: RandomAvatar(
                                  _getAvatarSeed(),
                                  height: 40,
                                  width: 40,
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
                            if (widget.isTemporary)
                              StatusText(state: state, userId: widget.userId),
                          ],
                        ),
                      ],
                    ),
                  )
                  : GestureDetector(
                    onTap: () async {
                      final users = await context
                          .read<ChatMessageCubit>()
                          .getOtherUser(otherUser: _getOtherUserId());
                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.black54,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.92,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                                child: Material(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: ProfileScreen(otherUser: users),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      height: 45,
                      width:
                          MediaQuery.of(context).size.width *
                          containerWidthMultiplier,
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
                                if (_useRandomAvatar)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: RandomAvatar(
                                      _getAvatarSeed(),
                                      height: 40,
                                      width: 40,
                                    ),
                                  )
                                else
                                  UserAvatar(
                                    radius: 20,
                                    avatarKey: _getOtherAvatar(),
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    if (roleIconAsset != null &&
                                        roleTooltip != null)
                                      Tooltip(
                                        message: roleTooltip,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 4,
                                          ),
                                          child: Image.asset(
                                            roleIconAsset,
                                            width: 16,
                                            height: 16,
                                            filterQuality: FilterQuality.none,
                                            cacheWidth: 32,
                                            cacheHeight: 32,
                                          ),
                                        ),
                                      ),
                                    Flexible(
                                      child: Text(
                                        _getOtherUserName(),
                                        style: TextStyle(
                                          color:
                                              isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (otherVerified == true)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Tooltip(
                                          message:
                                              S.of(context).verifiedAccount,
                                          child: Image.asset(
                                            'assets/verify.png',
                                            width: 14,
                                            height: 14,
                                            filterQuality: FilterQuality.none,
                                            cacheWidth: 28,
                                            cacheHeight: 28,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}
