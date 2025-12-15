import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';
import 'package:meet_now_admin_panel/features/moderation/widget/widget.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

@RoutePage()
class ModerationScreen extends StatelessWidget {
  const ModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<ModerationCubit, ModerationState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () => context.read<ModerationCubit>().clearError(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => context.read<ModerationCubit>().refresh(),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      pinned: true,
                      title: Text(
                        'Moderation Panel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                      actions: [
                        // Добавляем кнопку перезагрузки
                        IconButton(
                          onPressed: () =>
                              context.read<ModerationCubit>().refresh(),
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.grey[700],
                            size: 20,
                          ),
                          tooltip: 'Refresh data',
                        ),
                        if (state.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      ],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildCategorySelector(context, state),
                            const SizedBox(height: 16),
                            _buildContent(context, state),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Добавляем плавающую кнопку перезагрузки в углу
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.small(
                  onPressed: () => context.read<ModerationCubit>().refresh(),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey[700],
                  elevation: 2,
                  tooltip: 'Refresh',
                  child: state.isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey[700],
                          ),
                        )
                      : const Icon(Icons.refresh, size: 18),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, ModerationState state) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Добавляем кнопку перезагрузки в категории
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: IconButton(
                  onPressed: () => context.read<ModerationCubit>().refresh(),
                  icon: Icon(Icons.refresh, size: 16, color: Colors.grey[600]),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Refresh all data',
                ),
              ),
              const SizedBox(width: 12),
              _buildCategoryButton(
                context,
                'Reports',
                ModerationCategory.REPORTS,
                state,
              ),
              const SizedBox(width: 8),
              _buildCategoryButton(
                context,
                'Reports Stats',
                ModerationCategory.REPORTS_STATISTICS,
                state,
              ),
              const SizedBox(width: 8),
              _buildCategoryButton(
                context,
                'Support Stats',
                ModerationCategory.SUPPORT_STATISTICS,
                state,
              ),
              const SizedBox(width: 8),
              _buildCategoryButton(
                context,
                'Questions',
                ModerationCategory.QUESTIONS,
                state,
              ),
              const SizedBox(width: 8),
              _buildCategoryButton(
                context,
                'Unanswered',
                ModerationCategory.UNANSWERED_QUESTIONS,
                state,
              ),
              const SizedBox(width: 8),
              _buildCategoryButton(
                context,
                'Top Supporters',
                ModerationCategory.ACTIVE_SUPPORT_USERS,
                state,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Остальной код остается без изменений...

  Widget _buildCategoryButton(
    BuildContext context,
    String label,
    ModerationCategory category,
    ModerationState state,
  ) {
    final isSelected = state.selectedCategory == category;
    return GestureDetector(
      onTap: () => context.read<ModerationCubit>().changeCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue[200]! : Colors.grey[200]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.blue[700] : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ModerationState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text(
                'Loading data...',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    // Добавляем кнопку перезагрузки в каждый раздел
    return Column(
      children: [
        // Показываем кнопку перезагрузки в каждом разделе
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getCategoryTitle(state.selectedCategory),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              IconButton(
                onPressed: () => context.read<ModerationCubit>().refresh(),
                icon: Icon(Icons.refresh, size: 18, color: Colors.grey[600]),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                tooltip: 'Refresh this section',
              ),
            ],
          ),
        ),

        // Контент для каждого раздела
        _buildSectionContent(context, state),
      ],
    );
  }

  String _getCategoryTitle(ModerationCategory category) {
    switch (category) {
      case ModerationCategory.REPORTS:
        return 'Reports';
      case ModerationCategory.REPORTS_STATISTICS:
        return 'Reports Statistics';
      case ModerationCategory.SUPPORT_STATISTICS:
        return 'Support Statistics';
      case ModerationCategory.QUESTIONS:
        return 'Questions';
      case ModerationCategory.UNANSWERED_QUESTIONS:
        return 'Unanswered Questions';
      case ModerationCategory.USER_QUESTIONS:
        return 'User Questions';
      case ModerationCategory.ACTIVE_SUPPORT_USERS:
        return 'Top Support Users';
    }
  }

  Widget _buildSectionContent(BuildContext context, ModerationState state) {
    switch (state.selectedCategory) {
      case ModerationCategory.REPORTS:
        return _buildReportsContent(context, state);
      case ModerationCategory.REPORTS_STATISTICS:
        return _buildReportsStatistics(state);
      case ModerationCategory.SUPPORT_STATISTICS:
        return _buildSupportStatistics(state);
      case ModerationCategory.QUESTIONS:
        return _buildQuestionsContent(context, state);
      case ModerationCategory.UNANSWERED_QUESTIONS:
        return _buildUnansweredQuestions(context, state);
      case ModerationCategory.USER_QUESTIONS:
        return _buildUserQuestions(context, state);
      case ModerationCategory.ACTIVE_SUPPORT_USERS:
        return _buildActiveSupportUsers(state);
    }
  }

  Widget _buildReportsContent(BuildContext context, ModerationState state) {
    return Column(
      children: [
        _buildReportFilters(context),
        const SizedBox(height: 12),
        _buildSearchBar(context, state, 'Search reports...'),
        const SizedBox(height: 16),
        if (state.reportedContent.isEmpty)
          _buildEmptyReports()
        else
          ReportedContentList(contentItems: state.reportedContent),
      ],
    );
  }

  Widget _buildEmptyReports() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.flag_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No Reports Found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusFilter(context, 'All', null),
                const SizedBox(width: 8),
                _buildStatusFilter(context, 'Pending', ReportStatus.SENT),
                const SizedBox(width: 8),
                _buildStatusFilter(
                  context,
                  'In Process',
                  ReportStatus.IN_PROCESS,
                ),
                const SizedBox(width: 8),
                _buildStatusFilter(
                  context,
                  'Completed',
                  ReportStatus.COMPLETED,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilter(
    BuildContext context,
    String label,
    ReportStatus? status,
  ) {
    final state = context.watch<ModerationCubit>().state;
    final isSelected = state.selectedReportStatus == status;

    return GestureDetector(
      onTap: () {
        context.read<ModerationCubit>().filterReportsByStatus(status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    ModerationState state,
    String hint,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          onChanged: (value) {
            if (state.selectedCategory == ModerationCategory.REPORTS) {
              context.read<ModerationCubit>().searchReports(value);
            } else if (state.selectedCategory == ModerationCategory.QUESTIONS) {
              context.read<ModerationCubit>().searchQuestions(value);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            icon: Icon(Icons.search, size: 18, color: Colors.grey[500]),
            suffixIcon: state.searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, size: 16, color: Colors.grey[500]),
                    onPressed: () {
                      if (state.selectedCategory ==
                          ModerationCategory.REPORTS) {
                        context.read<ModerationCubit>().searchReports('');
                      } else if (state.selectedCategory ==
                          ModerationCategory.QUESTIONS) {
                        context.read<ModerationCubit>().searchQuestions('');
                      }
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildReportsStatistics(ModerationState state) {
    final stats = state.reportsStatistics;
    if (stats == null) return const SizedBox();

    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatCard(
                  'Total Reports',
                  stats.totalReports.toString(),
                  Icons.flag_outlined,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Sent',
                  stats.sentReports.toString(),
                  Icons.send_outlined,
                  Colors.orange,
                ),
                _buildStatCard(
                  'In Process',
                  stats.inProcessReports.toString(),
                  Icons.sync_outlined,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Completed',
                  stats.completedReports.toString(),
                  Icons.check_circle_outlined,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportStatistics(ModerationState state) {
    final stats = state.supportStatistics;
    if (stats == null) return const SizedBox();

    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatCard(
                  'Total Questions',
                  stats.totalQuestions.toString(),
                  Icons.question_answer_outlined,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Open Questions',
                  '0', // Временно, пока не получим данные
                  Icons.inbox_outlined,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Answered',
                  '0', // Временно, пока не получим данные
                  Icons.check_circle_outlined,
                  Colors.green,
                ),
                _buildStatCard(
                  'Closed',
                  '0', // Временно, пока не получим данные
                  Icons.lock_outlined,
                  Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsContent(BuildContext context, ModerationState state) {
    return Column(
      children: [
        _buildSearchBar(context, state, 'Search questions...'),
        const SizedBox(height: 16),
        if (state.questions.isEmpty)
          _buildEmptyQuestions()
        else
          QuestionsList(questions: state.questions),
      ],
    );
  }

  Widget _buildEmptyQuestions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.question_answer_outlined,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No Questions Found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnansweredQuestions(
    BuildContext context,
    ModerationState state,
  ) {
    final questions = state.unansweredQuestions ?? [];

    return Column(
      children: [
        if (questions.isEmpty)
          _buildEmptyUnansweredQuestions()
        else
          QuestionsList(questions: questions),
      ],
    );
  }

  Widget _buildEmptyUnansweredQuestions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 48, color: Colors.green[300]),
          const SizedBox(height: 12),
          Text(
            'All questions answered!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Great job! All questions have been answered.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserQuestions(BuildContext context, ModerationState state) {
    final questions = state.userQuestions ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.selectedUserId != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Questions by User: ${state.selectedUserId}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
        if (questions.isEmpty)
          _buildEmptyQuestions()
        else
          QuestionsList(questions: questions),
      ],
    );
  }

  Widget _buildActiveSupportUsers(ModerationState state) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Support Users',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            if (state.activeSupportUsers.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No support users found',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            else
              ...state.activeSupportUsers.map((user) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          user.userId.substring(0, 2).toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.userId,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                              ),
                            ),
                            Text(
                              '${user.questionCount} questions answered',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Score: ${user.questionCount}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
