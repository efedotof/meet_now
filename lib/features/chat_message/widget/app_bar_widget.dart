import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/server/model/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app/server/model/user_activity/user_activity.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.chatModel,
    required this.userId,
    required this.onBackPressed,
    required this.isTemporary,
    this.timerText,
  });

  final PermanentChatResponseDto? chatModel;
  final String userId;
  final VoidCallback onBackPressed;
  final bool isTemporary;
  final String? timerText;

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
            if (widget.chatModel != null)
              IconButton(
                icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
                onPressed: () {},
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

