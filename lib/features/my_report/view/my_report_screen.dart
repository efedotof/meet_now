import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/my_report/cubit/report_cubit.dart';
import 'package:meet_now_app/features/my_report/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class MyReportScreen extends StatefulWidget {
  const MyReportScreen({super.key});

  @override
  State<MyReportScreen> createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportCubit>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 600,
                ),
                child: SkeletonTheme(
                  shimmerGradient: const LinearGradient(
                    colors: [
                      Color(0xFFD8E3E7),
                      Color(0xFFC8D5DA),
                      Color(0xFFD8E3E7),
                    ],
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
                  child: Container(
                    margin: EdgeInsets.all(isMobile ? 0 : 16),
                    decoration:
                        isMobile
                            ? null
                            : BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                    child: RefreshIndicator(
                      onRefresh:
                          () => context.read<ReportCubit>().loadReports(),
                      child: BlocBuilder<ReportCubit, ReportState>(
                        builder: (context, state) {
                          return state.when(
                            initial: () => ReportsSkeleton(isMobile: isMobile),
                            loading: () => ReportsSkeleton(isMobile: isMobile),
                            error:
                                (msg) => Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                                    child: Text("${S.of(context).error} $msg"),
                                  ),
                                ),
                            loaded: (reports) {
                              if (reports.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                                    child: Text(
                                      S.of(context).there_are_no_complaints_yet,
                                    ),
                                  ),
                                );
                              }
                              return ReportWrap(
                                reports: reports,
                                isMobile: isMobile,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const AppBarWidget(),
        ],
      ),
    );
  }
}
