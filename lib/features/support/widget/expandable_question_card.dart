import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';
import 'answer_card.dart';
import 'info_card.dart';
import 'info_row.dart';
import 'status_chip.dart';

class ExpandableQuestionCard extends StatefulWidget {
  final Question question;
  final bool isInitiallyExpanded;
  final bool isMobile;

  const ExpandableQuestionCard({
    super.key,
    required this.question,
    required this.isMobile,
    this.isInitiallyExpanded = false,
  });

  @override
  State<ExpandableQuestionCard> createState() => _ExpandableQuestionCardState();
}

class _ExpandableQuestionCardState extends State<ExpandableQuestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  String _truncateId(String id) {
    if (id.length <= 12) return id;
    return '${id.substring(0, 8)}...${id.substring(id.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: widget.isMobile ? 12 : 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.isMobile ? 12 : 16),
      ),
      child: ClipRect(
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.isMobile ? 12 : 16),
                topRight: Radius.circular(widget.isMobile ? 12 : 16),
              ),
              onTap: _toggleExpansion,
              child: Padding(
                padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.question.title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: widget.isMobile ? null : 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusChip(
                          status: widget.question.status,
                          isMobile: widget.isMobile,
                        ),
                        const SizedBox(width: 8),
                        RotationTransition(
                          turns: Tween(
                            begin: 0.0,
                            end: 0.5,
                          ).animate(_animation),
                          child: Icon(
                            Icons.expand_more,
                            color: Colors.grey[600],
                            size: widget.isMobile ? 24 : 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.question.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontSize: widget.isMobile ? null : 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: widget.isMobile ? 16 : 18,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.question.answers.length}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: widget.isMobile ? null : 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(widget.question.updatedAt),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: widget.isMobile ? null : 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _animation,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 16 : 20,
                  vertical: widget.isMobile ? 0 : 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    SizedBox(height: widget.isMobile ? 16 : 20),
                    InfoCard(
                      S.of(context).description,
                      widget.question.description,
                      isMobile: widget.isMobile,
                    ),
                    SizedBox(height: widget.isMobile ? 16 : 20),
                    InfoCard(
                      S.of(context).information,
                      null,
                      isMobile: widget.isMobile,
                      children: [
                        InfoRow(
                          S.of(context).generated,
                          _formatDate(widget.question.createdAt),
                          isMobile: widget.isMobile,
                        ),
                        InfoRow(
                          S.of(context).updated,
                          _formatDate(widget.question.updatedAt),
                          isMobile: widget.isMobile,
                        ),
                        InfoRow(
                          S.of(context).question_id,
                          _truncateId(widget.question.id),
                          isMobile: widget.isMobile,
                        ),
                      ],
                    ),
                    SizedBox(height: widget.isMobile ? 16 : 20),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' ${S.of(context).answers} (${widget.question.answers.length})',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontSize: widget.isMobile ? null : 18,
                              ),
                            ),
                            SizedBox(height: widget.isMobile ? 8 : 12),
                            ...widget.question.answers.map(
                              (a) => AnswerCard(answer: a),
                            ),
                            if (widget.question.answers.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: widget.isMobile ? 16 : 20,
                                ),
                                child: Text(
                                  S.of(context).there_are_no_answers_yet,
                                  style: TextStyle(
                                    fontSize: widget.isMobile ? null : 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: widget.isMobile ? 8 : 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
