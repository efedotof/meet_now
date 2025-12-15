import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/login/cubit/login_cubit.dart';
import 'package:meet_now_admin_panel/features/login/widget/widget.dart';
import 'package:meet_now_admin_panel/route/app_router.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginSuccess) {
          context.replaceRoute(MainHomeRoute());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  HeaderSection(),
                  SizedBox(height: 32),
                  LoginCard(),
                  SizedBox(height: 24),
                  FooterSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
