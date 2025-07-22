import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';

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
                'Основная информация',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: TextFormField(
                  initialValue: formData.firstname,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value!.isEmpty ? 'Введите имя' : null,
                  onChanged: (value) => formData.firstname = value,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: TextFormField(
                  initialValue: formData.subname,
                  decoration: const InputDecoration(
                    labelText: 'Фамилия',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Введите фамилию' : null,
                  onChanged: (value) => formData.subname = value,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: TextFormField(
                  initialValue: formData.age > 0 ? formData.age.toString() : '',
                  decoration: const InputDecoration(
                    labelText: 'Возраст',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите возраст';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 14) {
                      return 'Минимальный возраст 14 лет';
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
