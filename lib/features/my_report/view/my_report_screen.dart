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
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
              child: RefreshIndicator(
                onRefresh: () => context.read<ReportCubit>().loadReports(),
                child: BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const ReportsSkeleton(),
                      loading: () => const ReportsSkeleton(),
                      error:
                          (msg) => Center(
                            child: Text("${S.of(context).error} $msg"),
                          ),
                      loaded: (reports) {
                        if (reports.isEmpty) {
                          return Center(
                            child: Text(
                              S.of(context).there_are_no_complaints_yet,
                            ),
                          );
                        }
                        return ReportWrap(reports: reports);
                      },
                    );
                  },
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
