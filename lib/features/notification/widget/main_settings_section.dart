import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/notification/cubit/notification_cubit.dart';

import 'switch_item.dart';

class MainSettingsSection extends StatelessWidget {
  const MainSettingsSection({
    super.key,
    required this.enableNotifications,
    required this.enableSound,
    required this.enableVibration,
    required this.enableBadge,
    required this.enablePreviews,
    required this.silentMode,
    required this.quietHoursEnabled,
  });

  final bool enableNotifications;
  final bool enableSound;
  final bool enableVibration;
  final bool enableBadge;
  final bool enablePreviews;
  final bool silentMode;
  final bool quietHoursEnabled;

  void _showQuietHoursDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Настройка тихих часов'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Настройка тихих часов будет добавлена в следующем обновлении.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Основные настройки',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchItem(
            title: 'Включить уведомления',
            value: enableNotifications,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleSetting(
                'enable_notifications',
                value,
              );
            },
            icon: Icons.notifications,
          ),

          SwitchItem(
            title: 'Звук',
            value: enableSound,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleSetting(
                'enable_sound',
                value,
              );
            },
            icon: Icons.volume_up,
          ),

          SwitchItem(
            title: 'Вибрация',
            value: enableVibration,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleSetting(
                'enable_vibration',
                value,
              );
            },
            icon: Icons.vibration,
          ),

          SwitchItem(
            title: 'Значок счётчика',
            value: enableBadge,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleSetting(
                'enable_badge',
                value,
              );
            },
            icon: Icons.circle_notifications,
          ),

          SwitchItem(
            title: 'Показывать содержимое',
            value: enablePreviews,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleSetting(
                'enable_previews',
                value,
              );
            },
            icon: Icons.preview,
          ),

          SwitchItem(
            title: 'Тихий режим',
            value: silentMode,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleSetting(
                'silent_mode',
                value,
              );
            },
            icon: Icons.phone_in_talk,
          ),

          SwitchItem(
            title: 'Тихие часы',
            value: quietHoursEnabled,
            onChanged: (value) {
              context.read<NotificationCubit>().toggleSetting(
                'quiet_hours_enabled',
                value,
              );
            },
            icon: Icons.access_time,
            trailing:
                quietHoursEnabled
                    ? TextButton(
                      onPressed: () {
                        _showQuietHoursDialog(context);
                      },
                      child: const Text('Настроить'),
                    )
                    : null,
          ),
        ],
      ),
    );
  }
}
