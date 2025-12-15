import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/login/cubit/login_cubit.dart';

class RememberMeOption extends StatelessWidget {
  const RememberMeOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.rememberMe != current.rememberMe,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.rememberMe,
              onChanged: (_) => context.read<LoginCubit>().toggleRememberMe(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              fillColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.blue[600];
                }
                return null;
              }),
            ),
            Text(
              'Remember me',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot password?',
                style: TextStyle(color: Colors.blue[600], fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }
}
