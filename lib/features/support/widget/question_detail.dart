import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
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
          InfoCard('Описание', question.description),
          const SizedBox(height: 16),
          InfoCard(
            'Информация',
            null,
            children: [
              InfoRow('Создан', _formatDate(question.createdAt)),
              InfoRow('Обновлен', _formatDate(question.updatedAt)),
              InfoRow('ID вопроса', question.id),
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
                        'Ответы (${question.answers.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      if (question.status != 'RESOLVED')
                        ElevatedButton.icon(
                          onPressed: () => _showAddAnswerDialog(context),
                          icon: const Icon(Icons.reply),
                          label: const Text('Добавить ответ'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...question.answers.map((a) => AnswerCard(answer: a)),
                  if (question.answers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Ответов пока нет'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAnswerDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить ответ'),
            content: TextField(
              controller: controller,
              autofocus: true,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Введите ваш ответ...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
