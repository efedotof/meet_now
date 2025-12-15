import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/login/cubit/login_cubit.dart';

class DemoCredentials extends StatelessWidget {
  const DemoCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.generalError != current.generalError,
      builder: (context, state) {
        return Column(
          children: [
            if (state.generalError != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.generalError!,
                        style: TextStyle(color: Colors.red[700], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Demo Credentials',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Username: developer\nPassword: dev123',
                    style: TextStyle(color: Colors.blue[700], fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}