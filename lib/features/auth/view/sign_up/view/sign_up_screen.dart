import 'dart:io';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/about_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/avatar_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/bottom_bar.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/credentials_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/personal_info_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpFormData formData = SignUpFormData();
  late PageController _pageController;
  int _currentPage = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      if (_currentPage < 3) {
        setState(() => _currentPage++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onRegisterPressed() {
    if (_formKeys[3].currentState!.validate()) {
      context.read<SignUpCubit>().registration(formData.toRegistration());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop =
        kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    final double buttonWidth =
        isDesktop ? math.min(400, screenWidth * 0.5) : double.infinity;

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        state.whenOrNull(
          success: () => context.replaceRoute(const MainHomeRoute()),
          error: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Регистрация'),
          leading:
              _currentPage > 0
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousPage,
                  )
                  : null,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentPage + 1) / 4,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              minHeight: 4,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PersonalInfoPage(
                    formKey: _formKeys[0],
                    formData: formData,
                    buttonWidth: buttonWidth,
                  ),
                  AboutPage(
                    formKey: _formKeys[1],
                    formData: formData,
                    buttonWidth: buttonWidth,
                  ),
                  AvatarPage(
                    formKey: _formKeys[2],
                    formData: formData,
                    buttonWidth: buttonWidth,
                  ),
                  CredentialsPage(
                    formKey: _formKeys[3],
                    formData: formData,
                    buttonWidth: buttonWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          currentPage: _currentPage,
          onNext: _nextPage,
          onRegister: _onRegisterPressed,
          buttonWidth: buttonWidth,
        ),
      ),
    );
  }
}
