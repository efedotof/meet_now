import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/notification/cubit/notification_cubit.dart';
import 'package:meet_now_app/features/notification/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;

          return Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child:
                      isDesktop
                          ? Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: _buildContent(context),
                            ),
                          )
                          : _buildContent(context),
                ),
              ),
              const AppBarWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded:
              (
                enableNotifications,
                enableSound,
                enableVibration,
                enableBadge,
                enablePreviews,
                quietHoursEnabled,
                silentMode,
                messageNotifications,
                friendRequestNotifications,
                systemNotifications,
              ) => Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  MainSettingsSection(
                    enableNotifications: enableNotifications,
                    enableSound: enableSound,
                    enableVibration: enableVibration,
                    enableBadge: enableBadge,
                    enablePreviews: enablePreviews,
                    silentMode: silentMode,
                    quietHoursEnabled: quietHoursEnabled,
                  ),
                  const SizedBox(height: 24),
                  SettingsToType(
                    systemNotifications: systemNotifications,
                    messageNotifications: messageNotifications,
                    friendRequestNotifications: friendRequestNotifications,
                  ),
                  const SizedBox(height: 32),
                  InformationSection(),
                ],
              ),
          error:
              (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${S.of(context).error} $message'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationCubit>().loadSettings();
                      },
                      child: Text(S.of(context).repeat),
                    ),
                  ],
                ),
              ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
