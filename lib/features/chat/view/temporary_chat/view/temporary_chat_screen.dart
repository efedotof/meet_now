import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/chat_tile.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class TemporaryChatScreen extends StatelessWidget {
  const TemporaryChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.temporaryChats)),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('${l10n.errorPrefix}: ${state.error}'));
          }

          if (state.temporaryChat.isEmpty) {
            return Center(child: Text(l10n.noTemporaryChats));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.temporaryChat.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chat = state.temporaryChat[index];
              return ChatTile(
                name: "${l10n.anonymousChat} ${index + 1}",
                lastMessage: l10n.tapToView,
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
