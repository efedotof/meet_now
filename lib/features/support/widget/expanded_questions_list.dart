import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';
import 'expandable_question_card.dart';

class ExpandedQuestionsList extends StatelessWidget {
  final List<Question> questions;
  final bool isMobile;

  const ExpandedQuestionsList(
    this.questions, {
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 20,
        left: isMobile ? 0 : 20,
        right: isMobile ? 0 : 20,
        top: isMobile ? 8 : 16,
      ),
      child: Column(
        children: [
          ...questions.map(
            (question) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 0,
                vertical: isMobile ? 8 : 12,
              ),
              child: ExpandableQuestionCard(
                question: question,
                isMobile: isMobile,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
