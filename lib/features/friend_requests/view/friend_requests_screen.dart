import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friend_requests/cubit/friend_cubit.dart';
import 'package:meet_now_app/features/friend_requests/widget/widget.dart';

@RoutePage()
class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запросы в друзья'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocProvider(
        create:
            (context) =>
                FriendCubit(friendInterface: context.read())..getIncomeFriend(),
        child: BlocBuilder<FriendCubit, FriendState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              emptyFriendRequest:
                  () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Нет запросов в друзья',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
              myFriendRequest:
                  (friendRequest) => ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: friendRequest.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final request = friendRequest[index];
                      return FriendRequestCard(friendRequest: request);
                    },
                  ),
            );
          },
        ),
      ),
    );
  }
}
