import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_in/cubit/sign_in_cubit.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  static const double mobileButtonWidth = double.infinity;
  static const double desktopButtonWidth = 300.0;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showSnackBar(BuildContext context, String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDesktop =
        kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    final double buttonWidth =
        isDesktop ? desktopButtonWidth : mobileButtonWidth;

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: BlocConsumer<SignInCubit, SignInState>(
              listener: (context, state) {
                state.maybeWhen(
                  error: (error) {
                    _showSnackBar(context, error, error: true);
                  },
                  success: () {
                    _showSnackBar(context,"Вход успешный");
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                final bool isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).welcomeBack,
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 32),

                    // Username
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: buttonWidth),
                      child: TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                          hintText: S.of(context).username,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? S.of(context).enterUsername
                                : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: buttonWidth),
                      child: TextFormField(
                        controller: password,
                        decoration: InputDecoration(
                          hintText: S.of(context).password,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        obscureText: _obscureText,
                        textInputAction: TextInputAction.done,
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? S.of(context).enterPassword
                                : null,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Button
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: buttonWidth),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    context.read<SignInCubit>().login(
                                          context: context,
                                          username: username,
                                          password: password,
                                        );
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(S.of(context).signIn),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
