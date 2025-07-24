import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/user_activity/user_activity_cubit.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';
import 'package:meet_now_app/server/model/user_activity/user_activity.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, this.chatModel, required this.userId});
  final Chat? chatModel;
  final String userId;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<UserActivityCubit, UserActivityState>(
      builder: (context, activityState) {
        return AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: theme.appBarTheme.elevation,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.maybePop(),
            color: theme.iconTheme.color,
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.secondary,
                child: const Icon(Icons.person, size: 24),
              ),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatModel != null
                        ? "${chatModel!.user1.firstname} ${chatModel!.user1.subname}"
                        : "Анонимный пользователь",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    activityState.when(
                      initial: () => "Добро пожаловать!",
                      activity: (UserActivity activity) {
                        switch (activity.activityType) {
                          case ActivityType.TYPING:
                            return 'печатает...';
                          case ActivityType.OFFLINE:
                            return 'куда-то потерялся(ась)...';
                          case ActivityType.SENDING_FILE:
                            return "отправляет файл(ы)...";
                          case ActivityType.SENDING_IMAGE:
                            return "отправляет изображение...";
                          case ActivityType.ONLINE:
                            return "он/она тут...";
                        }
                      },
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: activityState.when(
                        initial: () => theme.colorScheme.secondary,
                        activity: (activity) {
                          if (activity.userId == userId) {
                            return theme.colorScheme.secondary;
                          } else {
                            return Colors.green;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            if (chatModel != null)
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
                color: theme.iconTheme.color,
              ),
          ],
        );
      },
    );
  }
}
