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
    // if (state.isLoading) {
    //   return const ChatListSkeleton();
    // }

    if (state.error != null) {
      return Center(
        child: Text("${S.of(context).errorPrefix}: ${state.error}"),
      );
    }

    final (permanentChats, temporaryChats) = _getFilteredChats(state);

    final hasPermanentChats = permanentChats.isNotEmpty;
    final hasTemporaryChats = temporaryChats.isNotEmpty;
    final hasAnyChats = hasPermanentChats || hasTemporaryChats;

    if (!hasAnyChats) {
      return _buildEmptyState(context, state.selectedChatType);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPermanentChats) ...[
          if (state.selectedChatType == ChatType.all)
            _buildSectionTitle('Постоянные чаты'),
          _buildChatsList(
            permanentChats
                .map(
                  (chat) => _buildPermanentChatTile(
                    context,
                    chat,
                    state.currentUserId,
                  ),
                )
                .toList(),
          ),
        ],

        if (hasTemporaryChats) ...[
          if (state.selectedChatType == ChatType.all)
            _buildSectionTitle('Временные чаты'),
          _buildChatsList(
            temporaryChats
                .map(
                  (chat) => _buildTemporaryChatTile(
                    context,
                    chat,
                    state.currentUserId,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  (List<PermanentChatResponseDto>, List<TemporaryChat>) _getFilteredChats(
    ChatState state,
  ) {
    switch (state.selectedChatType) {
      case ChatType.all:
        final sortedPermanent = List<PermanentChatResponseDto>.from(
          state.permanentChat,
        )..sort(
          (a, b) => (b.lastMessageAt ?? DateTime(0)).compareTo(
            a.lastMessageAt ?? DateTime(0),
          ),
        );

        final sortedTemporary = List<TemporaryChat>.from(state.temporaryChat)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return (sortedPermanent, sortedTemporary);

      case ChatType.permanent:
        final sortedPermanent = List<PermanentChatResponseDto>.from(
          state.permanentChat,
        )..sort(
          (a, b) => (b.lastMessageAt ?? DateTime(0)).compareTo(
            a.lastMessageAt ?? DateTime(0),
          ),
        );
        return (sortedPermanent, []);

      case ChatType.temporary:
        final sortedTemporary = List<TemporaryChat>.from(state.temporaryChat)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return ([], sortedTemporary);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildChatsList(List<Widget> chatTiles) {
    return Wrap(spacing: 12, runSpacing: 12, children: chatTiles);
  }

  Widget _buildPermanentChatTile(
    BuildContext context,
    PermanentChatResponseDto chat,
    String? currentUserId,
  ) {
    final (name, avatar) = _getPermanentChatDisplayData(chat, currentUserId);

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
  }

  Widget _buildTemporaryChatTile(
    BuildContext context,
    TemporaryChat chat,
    String? currentUserId,
  ) {
    final (name, avatar) = _getTemporaryChatDisplayData(chat, currentUserId);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: BlocProvider(
        create:
            (context) => SyncTimerCubit(
              timerRepository: TimerRepository(
                socketService: context.read<SocketServiceImpl>(),
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
              avatar: avatar,
              chat: chat,
              remainingTime: timerState.remainingTime,
            );
          },
        ),
      ),
    );
  }

  (String name, String? avatar) _getPermanentChatDisplayData(
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

  (String name, String? avatar) _getTemporaryChatDisplayData(
    TemporaryChat chat,
    String? currentUserId,
  ) {
    return ('Анонимный чат', null);
  }

  Widget _buildEmptyState(BuildContext context, ChatType chatType) {
    String message;
    switch (chatType) {
      case ChatType.all:
        message = 'Нет чатов';
        break;
      case ChatType.permanent:
        message = 'Нет постоянных чатов';
        break;
      case ChatType.temporary:
        message = 'Нет временных чатов';
        break;
    }

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
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
