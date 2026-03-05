import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/my_report/cubit/report_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class ReportWrap extends StatefulWidget {
  const ReportWrap({super.key, required this.reports, required this.isMobile});
  final List<Report> reports;
  final bool isMobile;

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
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius:
                isMobile
                    ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                    : BorderRadius.circular(20),
          ),
          margin:
              isMobile
                  ? EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                  )
                  : EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.1,
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                  ),
          child: DraggableScrollableSheet(
            initialChildSize: isMobile ? 0.95 : 0.8,
            minChildSize: isMobile ? 0.4 : 0.6,
            maxChildSize: isMobile ? 0.95 : 0.8,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMobile)
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
                      Text(
                        S.of(context).reportDetails,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow(
                        context,
                        S.of(context).reason,
                        _selectedReport?.reason ?? '',
                        isMobile: widget.isMobile,
                      ),
                      const SizedBox(height: 15),
                      _buildDetailRow(
                        context,
                        S.of(context).date,
                        _selectedReport?.createdAt.toLocal().toString() ?? '',
                        isMobile: widget.isMobile,
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
                                _statusText(_selectedReport!.status, context),
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
                            icon: const Icon(Icons.cancel, color: Colors.white),
                            label: Text(
                              S.of(context).revoke,
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 15 : 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  isMobile ? 12 : 16,
                                ),
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
                            padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 15 : 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isMobile ? 12 : 16,
                              ),
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

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    required bool isMobile,
  }) {
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
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(30),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: isMobile ? null : 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: widget.isMobile ? MediaQuery.of(context).size.height * 0.1 : 20,
        bottom: 20,
        left: widget.isMobile ? 0 : 20,
        right: widget.isMobile ? 0 : 20,
      ),
      itemCount: widget.reports.length,
      itemBuilder: (context, index) {
        final report = widget.reports[index];
        return GestureDetector(
          onTap: () => _showReportDetails(context, report),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: widget.isMobile ? 16 : 0,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.isMobile ? 16 : 20),
              ),
              child: Padding(
                padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${S.of(context).reason} ${report.reason}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: widget.isMobile ? null : 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${S.of(context).date} ${report.createdAt.toLocal()}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: widget.isMobile ? null : 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(_statusText(report.status, context)),
                          backgroundColor: _statusColor(report.status),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.isMobile ? null : 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
