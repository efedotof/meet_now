import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';
import 'package:meet_now_app_server/model/social/question/question_status.dart';

class SupportQuestionsList extends StatelessWidget {
  final List<Question> questions;

  const SupportQuestionsList({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: Text('Вопросы не найдены'));
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
                    _buildStatusChip(question.status),
                    const Spacer(),
                    Text(
                      'Ответов: ${question.answers.length}',
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

  Widget _buildStatusChip(QuestionStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case QuestionStatus.pending:
        backgroundColor = Colors.orange.withAlpha(2);
        textColor = Colors.orange;
      case QuestionStatus.received:
        backgroundColor = Colors.blue.withAlpha(2);
        textColor = Colors.blue;
      case QuestionStatus.resolved:
        backgroundColor = Colors.green.withAlpha(2);
        textColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
