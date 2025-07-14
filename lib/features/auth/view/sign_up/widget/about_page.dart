import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';

class AboutPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;

  const AboutPage({super.key, required this.formKey, required this.formData});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Расскажите о себе',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: widget.formData.description,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Описание',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Расскажите о себе' : null,
              onChanged: (value) => widget.formData.description = value,
            ),
            const SizedBox(height: 24),
            Text(
              'Цели знакомств',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  ['Дружба', 'Любовь', 'Общение'].map((e) {
                    final selected = widget.formData.purposes.contains(e);
                    return FilterChip(
                      label: Text(e),
                      selected: selected,
                      onSelected:
                          (val) => setState(() {
                            if (val) {
                              widget.formData.purposes.add(e);
                            } else {
                              widget.formData.purposes.remove(e);
                            }
                          }),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Интересы', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  ['Спорт', 'Игры', 'Книги', 'Музыка'].map((e) {
                    final selected = widget.formData.interests.contains(e);
                    return FilterChip(
                      label: Text(e),
                      selected: selected,
                      onSelected:
                          (val) => setState(() {
                            if (val) {
                              widget.formData.interests.add(e);
                            } else {
                              widget.formData.interests.remove(e);
                            }
                          }),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
