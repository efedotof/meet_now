import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/users/cubit/users_cubit.dart';
import 'package:meet_now_admin_panel/features/users/widget/user_ui_models.dart';
import 'package:meet_now_admin_panel/features/users/widget/widget.dart';

@RoutePage()
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () => context.read<UsersCubit>().refresh(),
        child: CustomScrollView(
          slivers: [
            const UsersHeader(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const UsersLoading();
                    }
                    
                    final stats = UsersStats.fromUsers(state.users);
                    
                    return Column(
                      children: [
                        UsersStatsCard(stats: stats),
                        const SizedBox(height: 20),
                        UsersSearch(searchQuery: state.searchQuery),
                        const SizedBox(height: 20),
                        UsersList(users: state.users),
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