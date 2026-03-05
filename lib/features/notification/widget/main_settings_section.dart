import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/notification/cubit/notification_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
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
            title: Text(S.of(context).setting_up_a_quiet_clock),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S
                      .of(context)
                      .the_quiet_clock_setting_will_be_added_in_the_next_update,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).close),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsets.all(isDesktop ? 0 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).basic_settings,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SwitchItem(
                title: S.of(context).enable_notifications,
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
                title: S.of(context).sound,
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
                title: S.of(context).vibration,
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
                title: S.of(context).the_counter_icon,
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
                title: S.of(context).show_content,
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
                title: S.of(context).quiet_mode,
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
                title: S.of(context).quiet_hours,
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
                          child: Text(S.of(context).to_configure),
                        )
                        : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
