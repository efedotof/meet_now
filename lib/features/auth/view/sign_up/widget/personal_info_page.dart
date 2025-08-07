import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';

class PersonalInfoPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;
  final double buttonWidth;
  const PersonalInfoPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).personalInfo,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: TextFormField(
                  initialValue: formData.firstname,
                  decoration: InputDecoration(
                    labelText: S.of(context).firstName,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? S.of(context).enterFirstName : null,
                  onChanged: (value) => formData.firstname = value,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: TextFormField(
                  initialValue: formData.subname,
                  decoration: InputDecoration(
                    labelText: S.of(context).lastName,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? S.of(context).enterLastName : null,
                  onChanged: (value) => formData.subname = value,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: TextFormField(
                  initialValue: formData.age > 0 ? formData.age.toString() : '',
                  decoration: InputDecoration(
                    labelText: S.of(context).age,
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).enterAge;
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 14) {
                      return S.of(context).minAge;
                    }
                    return null;
                  },
                  onChanged: (value) => formData.age = int.tryParse(value) ?? 0,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: TextFormField(
                  initialValue: formData.city,
                  decoration: const InputDecoration(
                    labelText: 'Город',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  validator: (value) => value!.isEmpty ? 'Введите город' : null,
                  onChanged: (value) => formData.city = value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
