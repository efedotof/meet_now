import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/user_activity/user_activity.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.chatModel,
    required this.userId,
    required this.onBackPressed,
    required this.isTemporary,
    this.remainingSeconds,
  });

  final Chat? chatModel;
  final String userId;
  final VoidCallback onBackPressed;
  final bool isTemporary;
  final int? remainingSeconds;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatModel != null
                        ? "${widget.chatModel!.user1.firstname} ${widget.chatModel!.user1.subname}"
                        : S.of(context).anonymousUser,
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
                      initial:
                          () => Text(
                            S.of(context).connecting,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            if (widget.chatModel != null)
              IconButton(
                icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
                onPressed: () {},
              ),
            if (widget.isTemporary && widget.remainingSeconds != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    _formatTime(widget.remainingSeconds!),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          widget.remainingSeconds! < 60
                              ? Colors.red
                              : theme.colorScheme.onSurface,
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
