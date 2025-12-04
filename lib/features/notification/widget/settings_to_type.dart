import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/notification/cubit/notification_cubit.dart';

import 'switch_item.dart';

class SettingsToType extends StatelessWidget {
  const SettingsToType({
    super.key,
    required this.systemNotifications,
    required this.messageNotifications,
    required this.friendRequestNotifications,
  });
  final bool systemNotifications;
  final bool messageNotifications;
  final bool friendRequestNotifications;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Типы уведомлений',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchItem(
            title: 'Сообщения',
            subtitle: 'Новые сообщения в чатах',
            value: messageNotifications,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleActionSetting(
                'open_chat',
                value,
              );
            },
            icon: Icons.message,
          ),

          SwitchItem(
            title: 'Запросы в друзья',
            subtitle: 'Новые запросы на добавление в друзья',
            value: friendRequestNotifications,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleActionSetting(
                'view_friend_requests',
                value,
              );
            },
            icon: Icons.person_add,
          ),

          SwitchItem(
            title: 'Системные уведомления',
            subtitle: 'Обновления и системные сообщения',
            value: systemNotifications,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleActionSetting(
                'system_notification',
                value,
              );
            },
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }
}
