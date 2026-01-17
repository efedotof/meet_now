import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';
import 'expandable_question_card.dart';

class ExpandedQuestionsList extends StatelessWidget {
  final List<Question> questions;

  const ExpandedQuestionsList(this.questions, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ...questions.map(
            (question) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpandableQuestionCard(question: question),
            ),
          ),
        ],
      ),
    );
  }
}
