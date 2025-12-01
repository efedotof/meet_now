import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friend_requests/cubit/friend_cubit.dart';
import 'package:meet_now_app/features/friend_requests/widget/widget.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запросы в друзья'),
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
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
        child: BlocProvider(
          create:
              (context) =>
                  FriendCubit(friendInterface: context.read())
                    ..getIncomeFriend(),
          child: BlocBuilder<FriendCubit, FriendState>(
            builder: (context, state) {
              return state.when(
                initial: () => const FriendRequestsSkeleton(),
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
      ),
    );
  }
}
