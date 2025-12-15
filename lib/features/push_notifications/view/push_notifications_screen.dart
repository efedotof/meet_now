import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';
import 'package:meet_now_admin_panel/features/push_notifications/widget/widget.dart';

@RoutePage()
class PushNotificationsScreen extends StatelessWidget {
  const PushNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () => context.read<PushNotificationsCubit>().refresh(),
        child: CustomScrollView(
          slivers: [
            const PushNotificationsHeader(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child:
                    BlocBuilder<PushNotificationsCubit, PushNotificationsState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const PushNotificationsLoading();
                        }
                        return Column(
                          children: [
                            NotificationStatsCard(stats: state.stats),
                            const SizedBox(height: 24),
                            ComposeNotificationCard(
                              composeData: state.composeData,
                            ),
                            const SizedBox(height: 24),
                            SentNotificationsList(
                              notifications: state.sentNotifications,
                              searchQuery: state.searchQuery,
                            ),
                            const SizedBox(height: 32),
                          ],
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
