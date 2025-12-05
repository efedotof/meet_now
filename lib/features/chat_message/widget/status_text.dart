import 'package:flutter/material.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/user_activity/user_activity.dart';

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.state, required this.userId});
  final UserActivityState state;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: state.when(
        initial: () {
          return Text(
            S.of(context).connecting,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
        activity: (UserActivity activity) {
          if (activity.userId == userId) return const SizedBox();

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
                  : Theme.of(context).colorScheme.onPrimaryContainer;

          return Text(
            statusText,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: statusColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
}
