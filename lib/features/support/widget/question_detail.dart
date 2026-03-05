import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';

import 'answer_card.dart';
import 'info_card.dart';
import 'info_row.dart';
import 'status_chip.dart';

class QuestionDetail extends StatelessWidget {
  final Question question;
  final bool isMobile;

  const QuestionDetail(this.question, {super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: isMobile ? 100 : 120),

        SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: isMobile ? null : 28),
                    ),
                  ),
                  StatusChip(
                    status: question.status.toString(),
                    isMobile: isMobile,
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 20),
              InfoCard(
                S.of(context).description,
                question.description,
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 16 : 20),
              InfoCard(
                S.of(context).information,
                null,
                isMobile: isMobile,
                children: [
                  InfoRow(
                    S.of(context).generated,
                    _formatDate(question.createdAt),
                    isMobile: isMobile,
                  ),
                  InfoRow(
                    S.of(context).updated,
                    _formatDate(question.updatedAt),
                    isMobile: isMobile,
                  ),
                  InfoRow(
                    S.of(context).question_id,
                    question.id,
                    isMobile: isMobile,
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ' ${S.of(context).answers} (${question.answers.length})',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontSize: isMobile ? null : 18),
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
                      SizedBox(height: isMobile ? 8 : 12),
                      ...question.answers.map(
                        (a) => AnswerCard(answer: a, isMobile: isMobile),
                      ),
                      if (question.answers.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 16 : 20,
                          ),
                          child: Text(
                            S.of(context).there_are_no_answers_yet,
                            style: TextStyle(fontSize: isMobile ? null : 16),
                          ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileLocal = screenWidth < 600;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding:
                isMobileLocal
                    ? const EdgeInsets.all(20)
                    : EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.1,
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                    ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobileLocal ? double.infinity : 500,
              ),
              child: Padding(
                padding: EdgeInsets.all(isMobileLocal ? 16 : 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      S.of(context).add_a_response,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: isMobileLocal ? null : 24),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: S.of(context).enter_your_answer,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: isMobileLocal ? 24 : 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            S.of(context).cancel,
                            style: TextStyle(
                              fontSize: isMobileLocal ? null : 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
