import 'package:flutter/material.dart';

import 'demo_credentials.dart';
import 'username_field.dart';
import 'login_button.dart';
import 'password_field.dart';
import 'remember_me_option.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const UsernameField(),
            const SizedBox(height: 16),
            const PasswordField(),
            const SizedBox(height: 16),
            const RememberMeOption(),
            const SizedBox(height: 24),
            const LoginButton(),
            const SizedBox(height: 16),
            const DemoCredentials(),
          ],
        ),
      ),
    );
  }
}