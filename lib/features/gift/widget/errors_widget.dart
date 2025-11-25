import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';

class ErrorsWidget extends StatelessWidget {
  final String message;

  const ErrorsWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ошибка: $message'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.read<GiftCubit>().loadInitialData(),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
