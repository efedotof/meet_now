import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:meet_now_admin_panel/features/dashboard/widget/widget.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                const DashboardHeader(),
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

  Widget _buildContent(BuildContext context, DashboardState state) {
    if (state.isLoading) {
      return const DashboardLoading();
    }

    if (state.error != null) {
      return _buildErrorState(context, state.error!);
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        StatsGrid(state: state),
        const SizedBox(height: 24),
        MeetingActivityChart(meetingStats: state.meetingStats),
        const SizedBox(height: 24),
        SystemAlerts(alerts: state.alerts),
        const SizedBox(height: 24),
        _buildAdditionalStats(state),
        const SizedBox(height: 24),
        LastUpdated(lastUpdated: state.lastUpdated),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Failed to load dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<DashboardCubit>().refresh(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalStats(DashboardState state) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Real-time Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatChip('Online Users', state.onlineUsers.toString()),
                _buildStatChip('New Users (24h)', state.newUsers.toString()),
                _buildStatChip('Active Chats', state.totalMeetings.toString()),
                _buildStatChip(
                  'System Health',
                  '${state.systemHealth.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[900],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
