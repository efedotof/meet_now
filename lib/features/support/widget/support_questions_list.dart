import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';

class SupportQuestionsList extends StatelessWidget {
  final List<Question> questions;

  const SupportQuestionsList({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Center(child: Text(S.of(context).no_questions_found));
    }

    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(
              question.title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatusChip(context, question.status),
                    const Spacer(),
                    Text(
                      '${S.of(context).responses} ${question.answers.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.read<SupportCubit>().getQuestion(question.id),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color backgroundColor = Colors.grey.withAlpha(20);
    Color textColor = Colors.grey;
    String statusText = status;

    switch (status) {
      case "PENDING":
        backgroundColor = Colors.orange.withAlpha(20);
        textColor = Colors.orange;
        statusText = S.of(context).AWAITING;
        break;
      case "RECEIVED":
        backgroundColor = Colors.blue.withAlpha(20);
        textColor = Colors.blue;
        statusText = S.of(context).RECEIVED;
        break;
      case "RESOLVED":
        backgroundColor = Colors.green.withAlpha(20);
        textColor = Colors.green;
        statusText = S.of(context).ITSDECIDED;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
