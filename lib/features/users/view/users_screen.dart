// users_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/users/cubit/users_cubit.dart';
import 'package:meet_now_admin_panel/features/users/widget/user_ui_models.dart';
// УДАЛИТЕ эту строку: import 'package:meet_now_admin_panel/features/users/widget/users_tab.dart';
import 'package:meet_now_admin_panel/features/users/widget/widget.dart';

@RoutePage()
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersCubit>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<UsersCubit>().clearError();
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<UsersCubit>().refresh();
            },
            child: CustomScrollView(
              slivers: [
                const UsersHeader(),

                // Верхняя часть: статистика, табы, поиск - ВСЕГДА показывается
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Статистика
                        UsersStatsCard(
                          stats: UsersStats.fromUsers(state.users),
                        ),
                        const SizedBox(height: 20),

                        // Вкладки
                        _buildTabs(state.activeTab, context),
                        const SizedBox(height: 20),

                        // Поиск
                        UsersSearch(searchQuery: state.searchQuery),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Средняя часть: индикатор загрузки
                if (state.isLoading)
                  const SliverToBoxAdapter(child: UsersLoading()),

                // Нижняя часть: список пользователей или пустое состояние
                if (!state.isLoading)
                  if (state.filteredUsers.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: EmptyUsers(
                          onClearSearch: state.searchQuery.isNotEmpty
                              ? () => context.read<UsersCubit>().search('')
                              : null,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: UserCard(user: state.filteredUsers[index]),
                          ),
                          childCount: state.filteredUsers.length,
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(UsersTab activeTab, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: UsersTab.values.map((tab) {
          final isActive = activeTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<UsersCubit>().changeTab(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue[50] : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isActive
                      ? Border.all(color: Colors.blue[200]!, width: 1)
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isActive ? Colors.blue[700] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isActive)
                      Container(
                        width: 24,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
