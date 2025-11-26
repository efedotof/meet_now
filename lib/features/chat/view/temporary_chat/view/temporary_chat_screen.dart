import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/chat_tile.dart';
import 'package:meet_now_app/features/chat/widget/temporary_chats_skeleton.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class TemporaryChatScreen extends StatelessWidget {
  const TemporaryChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.temporaryChats)),
      body: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [Color(0xFFD8E3E7), Color(0xFFC8D5DA), Color(0xFFD8E3E7)],
          stops: [0.1, 0.5, 0.9],
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [
            Color(0xFF222222),
            Color(0xFF242424),
            Color(0xFF2B2B2B),
            Color(0xFF242424),
            Color(0xFF222222),
          ],
          stops: [0.0, 0.2, 0.5, 0.8, 1],
          begin: Alignment(-2.4, -0.2),
          end: Alignment(2.4, 0.2),
          tileMode: TileMode.clamp,
        ),
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const TemporaryChatsSkeleton();
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
                  sendLastMessageAt: null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
