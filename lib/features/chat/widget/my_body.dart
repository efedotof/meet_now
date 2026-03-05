import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

import 'chat_list_skeleton.dart';
import 'chat_tile.dart';
import 'temporary_chat_tile.dart';

class MyBody extends StatelessWidget {
  const MyBody({
    super.key,
    required this.state,
    required this.onChatSelected,
    this.selectedPermanentChat,
    this.selectedTemporaryChat,
    this.forceShowAll = false,
  });

  final ChatState state;
  final Function({
    PermanentChatResponseDto? permanentChat,
    TemporaryChat? temporaryChat,
  })
  onChatSelected;
  final PermanentChatResponseDto? selectedPermanentChat;
  final TemporaryChat? selectedTemporaryChat;
  final bool forceShowAll;

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

    final currentUserId = state.currentUserId;
    final searchQuery = state.searchQuery.toLowerCase();

    List<PermanentChatResponseDto> permanentChats =
        List<PermanentChatResponseDto>.from(state.permanentChat)..sort(
          (a, b) => (b.lastMessageAt ?? DateTime(0)).compareTo(
            a.lastMessageAt ?? DateTime(0),
          ),
        );

    List<TemporaryChat> temporaryChats = List<TemporaryChat>.from(
      state.temporaryChat,
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (!forceShowAll) {
      if (state.selectedChatType == ChatType.permanent) temporaryChats = [];
      if (state.selectedChatType == ChatType.temporary) permanentChats = [];
    }

    if (searchQuery.isNotEmpty) {
      permanentChats =
          permanentChats.where((chat) {
            if (currentUserId == chat.user1Id) {
              final name =
                  '${chat.user2Firstname} ${chat.user2Subname}'.toLowerCase();
              return name.contains(searchQuery);
            } else {
              final name =
                  '${chat.user1Firstname} ${chat.user1Subname}'.toLowerCase();
              return name.contains(searchQuery);
            }
          }).toList();

      if (forceShowAll || state.selectedChatType != ChatType.permanent) {
        temporaryChats =
            temporaryChats.where((chat) {
              final anonymousChatName =
                  S.of(context).anonymous_chat.toLowerCase();
              return anonymousChatName.contains(searchQuery) ||
                  S
                      .of(context)
                      .this_is_an_anonymous_chat
                      .toLowerCase()
                      .contains(searchQuery);
            }).toList();
      }
    }

    if (permanentChats.isEmpty && temporaryChats.isEmpty) {
      String message;
      if (searchQuery.isNotEmpty) {
        message = S.of(context).nothingFound;
      } else {
        message =
            forceShowAll
                ? S.of(context).there_are_no_chats
                : switch (state.selectedChatType) {
                  ChatType.all => S.of(context).there_are_no_chats,
                  ChatType.permanent =>
                    S.of(context).there_are_no_permanent_chats,
                  ChatType.temporary =>
                    S.of(context).there_are_no_temporary_chats,
                };
      }

      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                searchQuery.isNotEmpty
                    ? Icons.search_off
                    : Icons.forum_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(message, style: Theme.of(context).textTheme.titleMedium),
              if (searchQuery.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    S.of(context).tryDifferentSearch,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!forceShowAll && state.selectedChatType == ChatType.all) ...[
          if (permanentChats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                S.of(context).constant_chats,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],

        if (permanentChats.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                permanentChats.map((chat) {
                  String name;
                  String? avatar;

                  if (currentUserId == chat.user1Id) {
                    name = '${chat.user2Firstname} ${chat.user2Subname}';
                    avatar = chat.user2Avatar;
                  } else {
                    name = '${chat.user1Firstname} ${chat.user1Subname}';
                    avatar = chat.user1Avatar;
                  }

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ChatTile(
                      key: ValueKey(chat.chatId),
                      name: name,
                      lastMessage:
                          chat.lastMessage ?? S.of(context).start_chatting,
                      unreadCount: chat.unreadCount,
                      avatar: avatar ?? '',
                      chat: chat,
                      sendLastMessageAt: chat.lastMessageAt,
                      onTap: () => onChatSelected(permanentChat: chat),
                      isSelected: selectedPermanentChat?.chatId == chat.chatId,
                    ),
                  );
                }).toList(),
          ),

        if (!forceShowAll && state.selectedChatType == ChatType.all) ...[
          if (temporaryChats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                S.of(context).temporary_chats,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],

        if (temporaryChats.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                temporaryChats.map((chat) {
                  final name = S.of(context).anonymous_chat;

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: BlocProvider(
                      create:
                          (context) => SyncTimerCubit(
                            timerRepository: TimerRepository(
                              socketService:
                                  context.read<SocketServiceInterface>(),
                            ),
                            tempChatId: chat.tempChatId,
                            userId: currentUserId ?? '',
                            totalTime: chat.durationMinutes * 60,
                          ),
                      child: BlocBuilder<SyncTimerCubit, SyncTimerState>(
                        builder: (context, timerState) {
                          return TemporaryChatTile(
                            name: name,
                            lastMessage:
                                S.of(context).this_is_an_anonymous_chat,
                            unreadCount: 0,
                            avatar: null,
                            chat: chat,
                            remainingTime: timerState.remainingTime,
                            onTap: () => onChatSelected(temporaryChat: chat),
                            isSelected:
                                selectedTemporaryChat?.tempChatId ==
                                chat.tempChatId,
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
          ),
      ],
    );
  }
}
