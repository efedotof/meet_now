import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/supports/create_question_request/create_question_request.dart';

class CreateQuestionDialog extends StatefulWidget {
  const CreateQuestionDialog({super.key});

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
    return AlertDialog(
      title: Text(S.of(context).create_a_question),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: S.of(context).heading,
                border: OutlineInputBorder(),
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
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator:
                  (v) =>
                      v == null || v.trim().isEmpty
                          ? S.of(context).enter_a_description
                          : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: _createQuestion,
          child: Text(S.of(context).to_create),
        ),
      ],
    );
  }
}
