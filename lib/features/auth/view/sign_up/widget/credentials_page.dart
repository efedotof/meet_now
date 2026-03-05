import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class CredentialsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;
  final double buttonWidth;
  final AutovalidateMode autovalidateMode;

  const CredentialsPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
    this.autovalidateMode = AutovalidateMode.disabled,
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

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Form(
        key: widget.formKey,
        autovalidateMode: widget.autovalidateMode,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.buttonWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).credentials,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: widget.formData.username,
                  decoration: InputDecoration(
                    labelText: S.of(context).username,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? S.of(context).enterUsername : null,
                  onChanged: (value) => widget.formData.username = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.formData.email,
                  decoration: InputDecoration(
                    labelText: S.of(context).email,
                    prefixIcon: const Icon(Icons.email_outlined),
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
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                ),
                const SizedBox(height: 32),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
                    children: [
                      TextSpan(text: S.of(context).byLoggingInYouAgreeToOur),
                      TextSpan(
                        text: S.of(context).termsOfUse,
                        style: TextStyle(
                          color: colors.primary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => _launchUrl(
                                    'https://mnapp.ru/docs/user_agreement.pdf',
                                  ),
                      ),
                      TextSpan(text: S.of(context).and),
                      TextSpan(
                        text: S.of(context).privacyPolicy,
                        style: TextStyle(
                          color: colors.primary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => _launchUrl(
                                    'https://mnapp.ru/docs/privacy_policy.pdf',
                                  ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
