import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/login/cubit/login_cubit.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.username != current.username ||
          previous.usernameError != current.usernameError,
      builder: (context, state) {
        return TextField(
          onChanged: context.read<LoginCubit>().updateUsername,
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[500]!, width: 2),
            ),
            errorText: state.usernameError,
            errorStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        );
      },
    );
  }
}