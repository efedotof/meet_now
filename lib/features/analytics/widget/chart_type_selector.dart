import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/analytics/cubit/analytics_cubit.dart';

class ChartTypeSelector extends StatelessWidget {
  const ChartTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildChartTypeButton(
                context,
                'Engagement',
                ChartType.engagement,
                state.selectedChart,
              ),
              const SizedBox(width: 8),
              _buildChartTypeButton(
                context,
                'Meetings',
                ChartType.meetings,
                state.selectedChart,
              ),
              const SizedBox(width: 8),
              _buildChartTypeButton(
                context,
                'Retention',
                ChartType.retention,
                state.selectedChart,
              ),
              const SizedBox(width: 8),
              _buildChartTypeButton(
                context,
                'Features',
                ChartType.features,
                state.selectedChart,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartTypeButton(
    BuildContext context,
    String label,
    ChartType chartType,
    ChartType selectedChart,
  ) {
    final isSelected = chartType == selectedChart;
    return ElevatedButton(
      onPressed: () =>
          context.read<AnalyticsCubit>().changeChartType(chartType),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[600] : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.grey[700],
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}