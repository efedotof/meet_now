import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';

class CredentialsPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;

  const CredentialsPage({
    super.key,
    required this.formKey,
    required this.formData,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Учетные данные',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: formData.username,
              decoration: const InputDecoration(
                labelText: 'Имя пользователя',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value!.isEmpty ? 'Введите логин' : null,
              onChanged: (value) => formData.username = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: formData.email,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Введите email';
                if (!value.contains('@')) return 'Некорректный email';
                return null;
              },
              onChanged: (value) => formData.email = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Введите пароль';
                if (value.length < 6) return 'Минимум 6 символов';
                return null;
              },
              onChanged: (value) => formData.password = value,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: formData.isSearchable,
                  onChanged: (val) => formData.isSearchable = val!,
                ),
                const Text('Разрешить поиск моего профиля'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
