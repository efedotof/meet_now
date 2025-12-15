import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/analytics/cubit/analytics_cubit.dart';

class AnalyticsChart extends StatelessWidget {
  final AnalyticsData data;
  final ChartType chartType;

  const AnalyticsChart({
    super.key,
    required this.data,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
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
              _getChartTitle(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(height: 200, child: _buildChart()),
          ],
        ),
      ),
    );
  }

  String _getChartTitle() {
    switch (chartType) {
      case ChartType.engagement:
        return 'Session Engagement';
      case ChartType.meetings:
        return 'Game Statistics';
      case ChartType.retention:
        return 'Friends Distribution';
      case ChartType.features:
        return 'Feature Usage';
    }
  }

  Widget _buildChart() {
    final chartData = _getChartData();
    if (chartData.isEmpty) {
      return const Center(
        child: Text('No data available', style: TextStyle(color: Colors.grey)),
      );
    }

    final maxValue = chartData
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: chartData.map((data) {
        final heightFactor = maxValue > 0 ? data.value / maxValue : 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              data.value.toInt().toString(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 24,
              height: 150 * heightFactor.toDouble(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [data.color, data.color.withAlpha(70)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.label.length > 6
                  ? '${data.label.substring(0, 6)}..'
                  : data.label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<ChartData> _getChartData() {
    switch (chartType) {
      case ChartType.engagement:
        return data.engagementData;
      case ChartType.meetings:
        return data.meetingData;
      case ChartType.retention:
        return data.retentionData;
      case ChartType.features:
        return data.featureUsage
            .map(
              (f) => ChartData(
                label: f.feature,
                value: f.usageCount.toDouble(),
                color: _getColorForFeature(f.feature),
              ),
            )
            .toList();
    }
  }

  Color _getColorForFeature(String feature) {
    final colors = {
      'Stickers': Colors.blue,
      'Gifts': Colors.green,
      'Chat Games': Colors.orange,
      'Interests': Colors.purple,
      'Purposes': Colors.red,
    };
    return colors[feature] ?? Colors.grey;
  }
}
