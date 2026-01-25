import 'dart:io';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/about_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/bottom_bar.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/credentials_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/interest_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/personal_info_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/purpose_page.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';
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
  ];

  int get _formKeyIndex {
    switch (_currentPage) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 4:
        return 2;
      default:
        return -1;
    }
  }

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
    _disableAutoValidation();

    final formKeyIndex = _formKeyIndex;
    if (formKeyIndex >= 0) {
      final formState = _formKeys[formKeyIndex].currentState;
      if (formState != null) {
        bool isValid = formState.validate();
        if (formKeyIndex == 0) {
          if (!_validatePersonalInfo()) {
            isValid = false;
          }
        }

        if (!isValid) {
          return;
        }
      }
    }

    if (_currentPage < 5) {
      setState(() => _currentPage++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validatePersonalInfo() {
    if (formData.city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).please_select_city_from_list),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (formData.firstname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).enterFirstName),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (formData.subname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).enterLastName),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (formData.age <= 0 || formData.age < 18 || formData.age > 65) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).enter_valid_age),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
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
    _disableAutoValidation();

    bool allFormsValid = true;

    if (_formKeys[0].currentState != null) {
      if (!_formKeys[0].currentState!.validate() || !_validatePersonalInfo()) {
        allFormsValid = false;
      }
    }

    if (_formKeys[1].currentState != null) {
      if (!_formKeys[1].currentState!.validate()) {
        allFormsValid = false;
      }
    }

    if (_formKeys[2].currentState != null) {
      if (!_formKeys[2].currentState!.validate()) {
        allFormsValid = false;
      }
    }

    if (allFormsValid) {
      context.read<SignUpCubit>().registration(formData.toRegistration());
    }
  }

  void _disableAutoValidation() {
    setState(() {});
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
          success: () => context.router.replaceAll([UploadsAvatarsRoute()]),
          error: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).registration),
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
              value: (_currentPage + 1) / 5,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              minHeight: 4,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: PersonalInfoPage(
                      formKey: _formKeys[0],
                      formData: formData,
                      buttonWidth: buttonWidth,
                      autovalidateMode: AutovalidateMode.disabled,
                    ),
                  ),
                  Center(
                    child: AboutPage(
                      formKey: _formKeys[1],
                      formData: formData,
                      buttonWidth: buttonWidth,
                      autovalidateMode: AutovalidateMode.disabled,
                    ),
                  ),
                  Center(
                    child: PurposePage(
                      formData: formData,
                      buttonWidth: buttonWidth,
                    ),
                  ),
                  Center(
                    child: InterestPage(
                      formData: formData,
                      buttonWidth: buttonWidth,
                    ),
                  ),
                  Center(
                    child: CredentialsPage(
                      formKey: _formKeys[2],
                      formData: formData,
                      buttonWidth: buttonWidth,
                      autovalidateMode: AutovalidateMode.disabled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          currentPage: _currentPage,
          totalPages: 5,
          onNext: _nextPage,
          onRegister: _onRegisterPressed,
          buttonWidth: buttonWidth,
        ),
      ),
    );
  }
}
