import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'chat_tile.dart';
import 'temporary_chats_banner.dart';

class MyBody extends StatelessWidget {
  const MyBody({super.key, required this.state});

  final ChatState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text("${S.of(context).errorPrefix}: ${state.error}"),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<ChatCubit>().refresh(),
      color: Theme.of(context).colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          if (state.temporaryChat.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TemporaryChatsBanner(count: state.temporaryChat.length),
              ),
            ),

          SliverPadding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                S.of(context).permanentChats,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          if (state.permanentChat.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.forum_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).noPermanentChats,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).startCommunicationHint,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(S.of(context).startCommunication),
                    ),
                  ],
                ),
              ),
            ),

          if (state.permanentChat.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final chat = state.permanentChat[index];
                return ChatTile(
                  name:
                      "${chat.user1.firstname ?? S.of(context).anonymous} ${chat.user1.subname ?? ''}",
                  lastMessage: "lastMessage",
                  unreadCount: 3,
                  avatar: chat.user1.avatar,
                );
              }, childCount: state.permanentChat.length),
            ),
        ],
      ),
    );
  }
}

