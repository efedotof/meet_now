import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';
import 'package:meet_now_admin_panel/features/moderation/widget/widget.dart';

@RoutePage()
class ModerationScreen extends StatelessWidget {
  const ModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () => context.read<ModerationCubit>().refresh(),
        child: CustomScrollView(
          slivers: [
            const ModerationHeader(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: BlocConsumer<ModerationCubit, ModerationState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const ModerationLoading();
                    }
                    return Column(
                      children: [
                        ModerationStats(
                          reportedContent: state.reportedContent,
                          statistics: state.reportsStatistics,
                        ),
                        const SizedBox(height: 20),
                        const ModerationFilters(),
                        const SizedBox(height: 16),
                        const ModerationSearch(),
                        const SizedBox(height: 20),
                        if (state.error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red[600]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    state.error!,
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        ReportedContentList(
                          contentItems: state.reportedContent,
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
