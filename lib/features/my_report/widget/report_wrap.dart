import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/my_report/cubit/report_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class ReportWrap extends StatefulWidget {
  const ReportWrap({super.key, required this.reports});
  final List<Report> reports;

  @override
  State<ReportWrap> createState() => _ReportWrapState();
}

class _ReportWrapState extends State<ReportWrap> {
  Report? _selectedReport;

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

  String _statusText(ReportStatus status, BuildContext context) {
    switch (status) {
      case ReportStatus.SENT:
        return S.of(context).shipped;
      case ReportStatus.IN_PROCESS:
        return S.of(context).inProcessing;
      case ReportStatus.COMPLETED:
        return S.of(context).completed;
    }
  }

  void _showReportDetails(BuildContext context, Report report) {
    _selectedReport = report;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.95,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(100),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).reportDetails,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow(
                            context,
                            S.of(context).reason,
                            _selectedReport?.reason ?? '',
                          ),
                          const SizedBox(height: 15),
                          _buildDetailRow(
                            context,
                            S.of(context).date,
                            _selectedReport?.createdAt.toLocal().toString() ??
                                '',
                          ),
                          const SizedBox(height: 15),
                          if (_selectedReport != null)
                            Row(
                              children: [
                                Text(
                                  S.of(context).status,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 10),
                                Chip(
                                  label: Text(
                                    _statusText(
                                      _selectedReport!.status,
                                      context,
                                    ),
                                  ),
                                  backgroundColor: _statusColor(
                                    _selectedReport!.status,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 30),
                          if (_selectedReport != null &&
                              _selectedReport!.status == ReportStatus.SENT)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<ReportCubit>().withdrawReport(
                                    _selectedReport!.id,
                                  );
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  S.of(context).revoke,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(20),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                S.of(context).close,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((_) {
      setState(() {
        _selectedReport = null;
      });
    });
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(30),
              width: 1,
            ),
          ),
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Wrap(
          children: List.generate(widget.reports.length, (index) {
            final report = widget.reports[index];
            return GestureDetector(
              onTap: () => _showReportDetails(context, report),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${S.of(context).reason} ${report.reason}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${S.of(context).date} ${report.createdAt.toLocal()}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(_statusText(report.status, context)),
                            backgroundColor: _statusColor(report.status),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
