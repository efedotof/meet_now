import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/analytics/cubit/analytics_cubit.dart';
import 'package:meet_now_admin_panel/features/analytics/widget/widget.dart';

@RoutePage()
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<AnalyticsCubit, AnalyticsState>(
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
            onRefresh: () => context.read<AnalyticsCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                const AnalyticsHeader(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AnalyticsCubit>().exportData(),
        tooltip: 'Export Analytics Data',
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnalyticsState state) {
    if (state.isLoading) {
      return const AnalyticsLoadings();
    }

    if (state.error != null) {
      return _buildErrorState(context, state.error!);
    }

    return Column(
      children: [
        const DateRangeSelector(),
        const SizedBox(height: 20),
        const ChartTypeSelector(),
        const SizedBox(height: 24),
        AnalyticsOverview(data: state.data),
        const SizedBox(height: 24),
        AnalyticsChart(data: state.data, chartType: state.selectedChart),
        const SizedBox(height: 24),
        FeatureUsageList(featureUsage: state.data.featureUsage),
        const SizedBox(height: 24),
        _buildAdditionalStats(state.data.additionalStats),
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
            'Failed to load analytics',
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
            onPressed: () => context.read<AnalyticsCubit>().refresh(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalStats(Map<String, dynamic> additionalStats) {
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
              'Platform Statistics',
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
              children: additionalStats.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatKey(entry.key),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatValue(entry.value),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .toLowerCase();
  }

  String _formatValue(dynamic value) {
    if (value is double) {
      return value.toStringAsFixed(1);
    }
    return value.toString();
  }
}
