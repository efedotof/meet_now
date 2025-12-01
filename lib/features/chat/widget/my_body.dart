import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/chat_type.dart';
import 'package:meet_now_app/features/chat_message/cubit/sync_timer/sync_timer_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

import 'chat_list_skeleton.dart';
import 'chat_tile.dart';
import 'temporary_chat_tile.dart';

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

    final currentUserId = state.currentUserId;

    List<PermanentChatResponseDto> permanentChats =
        List<PermanentChatResponseDto>.from(state.permanentChat)..sort(
          (a, b) => (b.lastMessageAt ?? DateTime(0)).compareTo(
            a.lastMessageAt ?? DateTime(0),
          ),
        );

    List<TemporaryChat> temporaryChats = List<TemporaryChat>.from(
      state.temporaryChat,
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (state.selectedChatType == ChatType.permanent) temporaryChats = [];
    if (state.selectedChatType == ChatType.temporary) permanentChats = [];

    if (permanentChats.isEmpty && temporaryChats.isEmpty) {
      String message = switch (state.selectedChatType) {
        ChatType.all => 'Нет чатов',
        ChatType.permanent => 'Нет постоянных чатов',
        ChatType.temporary => 'Нет временных чатов',
      };

      return SizedBox(
        height: 400,
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
              Text(message, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  S.of(context).startCommunicationHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (permanentChats.isNotEmpty) ...[
          if (state.selectedChatType == ChatType.all)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Постоянные чаты',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

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
                      name: name,
                      lastMessage: chat.lastMessage ?? "Начните общение",
                      unreadCount: chat.unreadCount,
                      avatar: avatar,
                      chat: chat,
                      sendLastMessageAt: chat.lastMessageAt,
                    ),
                  );
                }).toList(),
          ),
        ],

        if (temporaryChats.isNotEmpty) ...[
          if (state.selectedChatType == ChatType.all)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Временные чаты',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                temporaryChats.map((chat) {
                  const name = 'Анонимный чат';

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
                            lastMessage: "Это анонимный чат",
                            unreadCount: 0,
                            avatar: null,
                            chat: chat,
                            remainingTime: timerState.remainingTime,
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }
}
