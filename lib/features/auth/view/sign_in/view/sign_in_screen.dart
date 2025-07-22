import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_in/cubit/sign_in_cubit.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  static const double mobileButtonWidth = double.infinity;
  static const double desktopButtonWidth = 300.0;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 32),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: buttonWidth),
                  child: TextFormField(
                    controller: username,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 16),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: buttonWidth),
                  child: TextFormField(
                    controller: password,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 24),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: buttonWidth),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SignInCubit>().login(
                          context: context,
                          username: username,
                          password: password,
                        );
                      },
                      child: const Text('Sign In'),
                    ),
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
