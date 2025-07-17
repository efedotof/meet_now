import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/server/model/chat/chat.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, this.chatModel});
  final Chat? chatModel;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                chatModel != null
                    ? chatModel!.user1.isOnline
                        ? "В сети"
                        : "Оффлайн"
                    : "Неизвестно",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
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
  }
}
