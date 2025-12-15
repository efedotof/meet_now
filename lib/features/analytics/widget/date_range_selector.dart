import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/analytics/cubit/analytics_cubit.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        return Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  'Date Range:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_formatDate(state.dateRange.start)} - ${_formatDate(state.dateRange.end)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.date_range, color: Colors.blue[600]),
                  onPressed: () {
                    _showDateRangePicker(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDateRangePicker(BuildContext context) {
    final cubit = context.read<AnalyticsCubit>();
    
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Apply',
    ).then((value) {
      if (value != null) {
        final customRange = CustomDateTimeRange(
          start: value.start,
          end: value.end,
        );
        cubit.changeDateRange(customRange);
      }
    });
  }
}