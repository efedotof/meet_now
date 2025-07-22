import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/chat_tile.dart';

@RoutePage()
class TemporaryChatScreen extends StatelessWidget {
  const TemporaryChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Временные чаты")),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Ошибка: ${state.error}'));
          }

          if (state.temporaryChat.isEmpty) {
            return const Center(child: Text('Временных чатов нет'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.temporaryChat.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chat = state.temporaryChat[index];
              return ChatTile(
                name: 'Анонимный чат ${index + 1}',
                lastMessage: 'Нажмите, чтобы посмотреть',
                unreadCount: 0,
                temporaryChat: chat,
              );
            },
          );
        },
      ),
    );
  }
}
