import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/chat/chat_message_cubit.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.message, required this.chatId});
  final String message;
  final String chatId;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Ошибка: $message',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () => context.read<ChatMessageCubit>().connect(chatId),
            child: const Text('Повторить попытку'),
          ),
        ],
      ),
    );
  }
}
