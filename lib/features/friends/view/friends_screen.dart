import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';
import 'package:meet_now_app/features/friends/widget/widget.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendsCubit>().getFriendsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SkeletonTheme(
              shimmerGradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface.withAlpha(90),
                  Theme.of(context).colorScheme.surface.withAlpha(50),
                  Theme.of(context).colorScheme.surface.withAlpha(90),
                ],
                stops: const [0.1, 0.5, 0.9],
              ),
              darkShimmerGradient: LinearGradient(
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade700,
                  Colors.grey.shade800,
                ],
                stops: const [0.1, 0.5, 0.9],
              ),
              child: RefreshIndicator(
                onRefresh: () => context.read<FriendsCubit>().refreshFriend(),
                child: BlocBuilder<FriendsCubit, FriendsState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const FriendsSkeleton(),
                      friendsList: (friends) {
                        if (friends.isEmpty) {
                          return EmptyState();
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            FriendsList(friends: friends),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          const AppBarWidget(),
        ],
      ),
    );
  }
}
