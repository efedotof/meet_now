import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/widget.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';

@RoutePage()
@RoutePage()
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ChatCubit(
            socketServiceInterface: context.read<SocketServiceInterface>(),
            userModelAppInterface: context.read<UserModelAppInterface>(),
          )..refresh(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Чаты"),
              centerTitle: true,
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              ],
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (state.error != null) {
      return Center(child: Text("Ошибка: ${state.error}"));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ChatCubit>().refresh(),
      color: Theme.of(context).colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          // Временные чаты
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

          // Постоянные чаты
          SliverPadding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Постоянные чаты",
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
                      "У вас пока нет постоянных чатов",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Начните общение, чтобы добавить людей в друзья",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Начать общение'),
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
                      "${chat.user1.firstname ?? 'Аноним'} ${chat.user1.subname ?? ''}",
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
