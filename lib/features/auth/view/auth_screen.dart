import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => context.pushRoute(SignInRoute()),
              child: Text("SignIn"),
            ),
            OutlinedButton(
              onPressed: () => context.pushRoute(SignUpRoute()),
              child: Text("SignUp"),
            ),
          ],
        ),
      ),
    );
  }
}
