import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'package:meet_now_app_server/model/social/question/question.dart';

import 'answer_card.dart';
import 'info_card.dart';
import 'info_row.dart';
import 'status_chip.dart';

class QuestionDetail extends StatelessWidget {
  final Question question;
  const QuestionDetail(this.question, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),

        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  StatusChip(status: question.status.toString()),
                ],
              ),
              const SizedBox(height: 16),
              InfoCard(S.of(context).description, question.description),
              const SizedBox(height: 16),
              InfoCard(
                S.of(context).information,
                null,
                children: [
                  InfoRow(
                    S.of(context).generated,
                    _formatDate(question.createdAt),
                  ),
                  InfoRow(
                    S.of(context).updated,
                    _formatDate(question.updatedAt),
                  ),
                  InfoRow(S.of(context).question_id, question.id),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ' ${S.of(context).answers} (${question.answers.length})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          if (question.status != 'RESOLVED')
                            ElevatedButton.icon(
                              onPressed: () => _showAddAnswerDialog(context),
                              icon: const Icon(Icons.reply),
                              label: Text(S.of(context).add_a_response),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...question.answers.map((a) => AnswerCard(answer: a)),
                      if (question.answers.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(S.of(context).there_are_no_answers_yet),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddAnswerDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).add_a_response),
            content: TextField(
              controller: controller,
              autofocus: true,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: S.of(context).enter_your_answer,
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
