import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';

class AboutPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;
  final double buttonWidth;

  const AboutPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;
    return Center(
      child: Form(
        key: widget.formKey,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.buttonWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).tellAboutYourself,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                Text(
                  S.of(context).gender,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text(S.of(context).male),
                      selected: widget.formData.gender == 'м',
                      checkmarkColor: isDark ? Colors.black : Colors.white,
                      iconTheme: IconThemeData(
                        color: isDark ? Colors.black : Colors.white,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          widget.formData.gender = selected ? 'м' : '';
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: Text(S.of(context).female),
                      selected: widget.formData.gender == 'ж',
                      checkmarkColor: isDark ? Colors.black : Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          widget.formData.gender = selected ? 'ж' : '';
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                TextFormField(
                  initialValue: widget.formData.description,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: S.of(context).description,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? S.of(context).tellAboutYourselfValidation
                              : null,
                  onChanged: (value) => widget.formData.description = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
