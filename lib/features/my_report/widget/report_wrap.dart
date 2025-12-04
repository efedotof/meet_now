import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/my_report/cubit/report_cubit.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class ReportWrap extends StatelessWidget {
  const ReportWrap({super.key, required this.reports});
  final List<Report> reports;

  Color _statusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.SENT:
        return Colors.orange;
      case ReportStatus.IN_PROCESS:
        return Colors.blue;
      case ReportStatus.COMPLETED:
        return Colors.green;
    }
  }

  String _statusText(ReportStatus status) {
    switch (status) {
      case ReportStatus.SENT:
        return "Отправлено";
      case ReportStatus.IN_PROCESS:
        return "В обработке";
      case ReportStatus.COMPLETED:
        return "Завершено";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Wrap(
          children: List.generate(reports.length, (index) {
            final report = reports[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Причина: ${report.reason}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Дата: ${report.createdAt.toLocal()}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(_statusText(report.status)),
                          backgroundColor: _statusColor(report.status),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (report.status == ReportStatus.SENT)
                          TextButton.icon(
                            onPressed: () {
                              context.read<ReportCubit>().withdrawReport(
                                report.id,
                              );
                            },
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            label: const Text(
                              "Отозвать",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
