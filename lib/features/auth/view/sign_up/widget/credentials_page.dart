import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';

class CredentialsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;
  final double buttonWidth;

  const CredentialsPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.buttonWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).credentials,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: widget.formData.username,
                decoration: InputDecoration(
                  labelText: S.of(context).username,
                  prefixIcon: Icon(Icons.person),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? S.of(context).enterUsername : null,
                onChanged: (value) => widget.formData.username = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.formData.email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).enterEmail;
                  }
                  if (!value.contains('@')) return S.of(context).invalidEmail;
                  return null;
                },
                onChanged: (value) => widget.formData.email = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: S.of(context).password,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).enterPassword;
                  }
                  if (value.length < 6) return S.of(context).minPassword;
                  return null;
                },
                onChanged: (value) => widget.formData.password = value,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: widget.formData.isSearchable,
                    onChanged: (val) {
                      setState(() {
                        widget.formData.isSearchable = val!;
                      });
                    },
                  ),
                  Text(S.of(context).allowProfileSearch),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
