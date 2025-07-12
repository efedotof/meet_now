import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_in/cubit/sign_in_cubit.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: username,
              onChanged: (value) => username.text = value,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              onChanged: (value) => password.text = value,
            ),

            OutlinedButton(
              onPressed:
                  () => context.read<SignInCubit>().login(
                    context: context,
                    username: username,
                    password: password,
                  ),
              child: Text("SignIn"),
            ),
          ],
        ),
      ),
    );
  }
}
