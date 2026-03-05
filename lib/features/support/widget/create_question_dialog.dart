import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/supports/create_question_request/create_question_request.dart';

class CreateQuestionDialog extends StatefulWidget {
  final bool isMobile;
  const CreateQuestionDialog({super.key, required this.isMobile});

  @override
  State<CreateQuestionDialog> createState() => _CreateQuestionDialogState();
}

class _CreateQuestionDialogState extends State<CreateQuestionDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createQuestion() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SupportCubit>().createQuestion(
        CreateQuestionRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          widget.isMobile
              ? const EdgeInsets.all(20)
              : EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
                horizontal: MediaQuery.of(context).size.width * 0.2,
              ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: widget.isMobile ? double.infinity : 500,
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  S.of(context).create_a_question,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: widget.isMobile ? null : 24,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: S.of(context).heading,
                    border: const OutlineInputBorder(),
                  ),
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? S.of(context).enter_the_title
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: S.of(context).description,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? S.of(context).enter_a_description
                              : null,
                ),
                SizedBox(height: widget.isMobile ? 24 : 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        S.of(context).cancel,
                        style: TextStyle(fontSize: widget.isMobile ? null : 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _createQuestion,
                      child: Text(
                        S.of(context).to_create,
                        style: TextStyle(fontSize: widget.isMobile ? null : 16),
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
}
