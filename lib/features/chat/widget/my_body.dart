import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';

import 'chat_list_skeleton.dart';
import 'chat_tile.dart';
import 'temporary_chats_banner.dart';

class MyBody extends StatelessWidget {
  const MyBody({super.key, required this.state});

  final ChatState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const ChatListSkeleton();
    }

    if (state.error != null) {
      return Center(
        child: Text("${S.of(context).errorPrefix}: ${state.error}"),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ChatCubit>().refresh(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TemporaryChatsBanner(count: state.temporaryChat.length),
              ),
            ),
          // if (state.temporaryChat.isNotEmpty)
          //   SliverToBoxAdapter(
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 16,
          //         vertical: 8,
          //       ),
          //       child: TemporaryChatsBanner(count: state.temporaryChat.length),
          //     ),
          //   ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                S.of(context).permanentChats,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        S.of(context).startCommunicationHint,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (state.permanentChat.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final chat = state.permanentChat[index];
                final currentUserId = state.currentUserId;

                final (name, avatar) = _getChatDisplayData(chat, currentUserId);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ChatTile(
                    name: name,
                    lastMessage: chat.lastMessage ?? "Начните общение",
                    unreadCount: chat.unreadCount,
                    avatar: avatar,
                    chat: chat,
                    sendLastMessageAt: chat.lastMessageAt,
                  ),
                );
              }, childCount: state.permanentChat.length),
            ),
        ],
      ),
    );
  }

  (String name, String? avatar) _getChatDisplayData(
    PermanentChatResponseDto chat,
    String? currentUserId,
  ) {
    if (currentUserId == null) {
      return ('Unknown User', null);
    }

    if (currentUserId == chat.user1Id) {
      return ('${chat.user2Firstname} ${chat.user2Subname}', chat.user2Avatar);
    } else {
      return ('${chat.user1Firstname} ${chat.user1Subname}', chat.user1Avatar);
    }
  }
}
