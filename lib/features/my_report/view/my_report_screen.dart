import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/my_report/cubit/report_cubit.dart';
import 'package:meet_now_app/features/my_report/widget/widget.dart';
import 'package:meet_now_app_server/model/social/report/report.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class MyReportScreen extends StatelessWidget {
  const MyReportScreen({super.key});

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
    context.read<ReportCubit>().loadReports();
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [Color(0xFFD8E3E7), Color(0xFFC8D5DA), Color(0xFFD8E3E7)],
        stops: [0.1, 0.5, 0.9],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [0.0, 0.2, 0.5, 0.8, 1],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Мои жалобы"),
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<ReportCubit>().loadReports(),
          child: BlocBuilder<ReportCubit, ReportState>(
            builder: (context, state) {
              return state.when(
                initial: () => const ReportsSkeleton(),
                loading: () => const ReportsSkeleton(),
                error: (msg) => Center(child: Text("Ошибка: $msg")),
                loaded: (reports) {
                  if (reports.isEmpty) {
                    return const Center(child: Text("Жалоб пока нет"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text(_statusText(report.status)),
                                    backgroundColor: _statusColor(
                                      report.status,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (report.status == ReportStatus.SENT)
                                    TextButton.icon(
                                      onPressed: () {
                                        context
                                            .read<ReportCubit>()
                                            .withdrawReport(report.id);
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
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
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
