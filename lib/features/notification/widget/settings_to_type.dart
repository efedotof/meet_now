import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/notification/cubit/notification_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

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
          Text(
            S.of(context).types_of_notifications,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchItem(
            title: S.of(context).messages,
            subtitle: S.of(context).new_chat_messages,
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
            title: S.of(context).friend_requests,
            subtitle: S.of(context).new_friend_requests,
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
            title: S.of(context).system_notifications,
            subtitle: S.of(context).updates_and_system_messages,
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
