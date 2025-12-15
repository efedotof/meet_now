import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';
import 'package:meet_now_admin_panel/features/push_notifications/widget/notifications_history_list.dart';
import 'package:meet_now_admin_panel/features/push_notifications/widget/widget.dart';

@RoutePage()
class PushNotificationsScreen extends StatelessWidget {
  const PushNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<PushNotificationsCubit, PushNotificationsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<PushNotificationsCubit>().clearError();
          }

          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
            context.read<PushNotificationsCubit>().clearSuccessMessage();
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<PushNotificationsCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                PushNotificationsHeader(
                  onRefresh: () =>
                      context.read<PushNotificationsCubit>().refresh(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: _buildContent(context, state),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PushNotificationsState state) {
    if (state.isLoading && state.notificationHistory.isEmpty) {
      return const PushNotificationsLoading();
    }

    return Column(
      children: [
        // Статистика
        if (state.notificationStatistics != null && state.tokenCoverage != null)
          TokenCoverageCard(
            statistics: state.notificationStatistics!,
            coverage: state.tokenCoverage!,
          ),

        const SizedBox(height: 24),

        // Статистика истории
        if (state.notificationHistoryStats != null)
          NotificationHistoryStatsCard(
            stats: state.notificationHistoryStats!,
            onCleanup: (days) => context
                .read<PushNotificationsCubit>()
                .cleanupOldNotifications(days),
          ),

        const SizedBox(height: 24),

        // Компоновка уведомления
        ComposeNotificationCard(
          composeData: state.composeData,
          users: state.usersWithTokens,
          isSending: state.isSending,
          onSend: () =>
              context.read<PushNotificationsCubit>().sendNotification(),
          onTitleChanged: (value) =>
              context.read<PushNotificationsCubit>().updateComposeTitle(value),
          onMessageChanged: (value) => context
              .read<PushNotificationsCubit>()
              .updateComposeMessage(value),
          onTargetChanged: (value) =>
              context.read<PushNotificationsCubit>().updateComposeTarget(value),
          onTargetUserIdChanged: (value) => context
              .read<PushNotificationsCubit>()
              .updateComposeTargetUserId(value),
          onTargetTokenChanged: (value) => context
              .read<PushNotificationsCubit>()
              .updateComposeTargetPushToken(value),
          onPriorityChanged: (value) => context
              .read<PushNotificationsCubit>()
              .updateComposePriority(value),
          onDeepLinkChanged: (value) => context
              .read<PushNotificationsCubit>()
              .updateComposeDeepLink(value),
        ),

        const SizedBox(height: 24),

        // История уведомлений
        NotificationHistoryList(
          notifications: state.filteredHistory ?? state.notificationHistory,
          searchQuery: state.searchQuery,
          currentPage: state.currentPage,
          totalPages: state.totalPages,
          currentFilter: state.currentFilter,
          filterValue: state.filterValue,
          onSearch: (query) =>
              context.read<PushNotificationsCubit>().search(query),
          onClearFilters: () =>
              context.read<PushNotificationsCubit>().clearFilters(),
          onFilterByType: (type) => context
              .read<PushNotificationsCubit>()
              .loadNotificationHistoryByType(type),
          onFilterByStatus: (success) => context
              .read<PushNotificationsCubit>()
              .loadNotificationHistoryByStatus(success),
          onPageChanged: (page) =>
              context.read<PushNotificationsCubit>().changePage(page),
          onUserHistory: (userId) => context
              .read<PushNotificationsCubit>()
              .loadUserNotificationHistory(userId),
          onUserTokenStatus: (userId) => context
              .read<PushNotificationsCubit>()
              .loadUserTokenStatus(userId),
        ),

        const SizedBox(height: 32),

        // Пользователи с токенами
        UsersWithTokensCard(
          users: state.usersWithTokens,
          onlineUsers: state.onlineUsersWithTokens,
          selectedUserStatus: state.selectedUserTokenStatus,
          onLoadOnlineUsers: () => context
              .read<PushNotificationsCubit>()
              .loadOnlineUsersWithTokens(),
          onUserTokenStatus: (userId) => context
              .read<PushNotificationsCubit>()
              .loadUserTokenStatus(userId),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
