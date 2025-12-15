import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/system/cubit/system_cubit.dart';
import 'package:meet_now_admin_panel/features/system/widget/widget.dart';

@RoutePage()
class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () => context.read<SystemCubit>().refresh(),
        child: CustomScrollView(
          slivers: [
            const SystemHeader(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<SystemCubit, SystemState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const SystemLoading();
                    }
                    return Column(
                      children: [
                        SystemHealthCard(systemHealth: state.systemHealth),
                        const SizedBox(height: 20),
                        ServerStatusCard(serverStatus: state.serverStatus),
                        const SizedBox(height: 20),
                        SystemPerformanceCard(performance: state.performance),
                        const SizedBox(height: 20),
                        SystemConfigCard(config: state.config),
                        const SizedBox(height: 20),
                        BackupsCard(backups: state.backups),
                        const SizedBox(height: 20),
                        SystemLogsCard(
                          logs: state.systemLogs,
                          searchQuery: state.searchQuery,
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
