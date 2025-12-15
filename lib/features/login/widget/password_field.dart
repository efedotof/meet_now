import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/login/cubit/login_cubit.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.obscurePassword != current.obscurePassword ||
          previous.passwordError != current.passwordError,
      builder: (context, state) {
        return TextField(
          onChanged: context.read<LoginCubit>().updatePassword,
          obscureText: state.obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
              onPressed: context.read<LoginCubit>().togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[500]!, width: 2),
            ),
            errorText: state.passwordError,
            errorStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          onSubmitted: (_) => context.read<LoginCubit>().login(),
        );
      },
    );
  }
}
