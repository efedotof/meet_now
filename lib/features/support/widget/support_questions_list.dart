import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';

import 'status_chip.dart';

class SupportQuestionsList extends StatelessWidget {
  final List<Question> questions;
  final bool isMobile;

  const SupportQuestionsList({
    super.key,
    required this.questions,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Center(
        child: Text(
          S.of(context).no_questions_found,
          style: TextStyle(fontSize: isMobile ? null : 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 4 : 8,
      ),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Card(
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : 8,
            vertical: isMobile ? 4 : 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
          ),
          child: ListTile(
            title: Text(
              question.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: isMobile ? null : 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.description,
                  style: TextStyle(fontSize: isMobile ? null : 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    StatusChip(status: question.status, isMobile: isMobile),
                    const Spacer(),
                    Text(
                      '${S.of(context).responses} ${question.answers.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: isMobile ? null : 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.chevron_right, size: isMobile ? 24 : 28),
            onTap: () => context.read<SupportCubit>().getQuestion(question.id),
          ),
        );
      },
    );
  }
}
