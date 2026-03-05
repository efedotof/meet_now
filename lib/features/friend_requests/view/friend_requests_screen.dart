import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friend_requests/cubit/friend_cubit.dart';
import 'package:meet_now_app/features/friend_requests/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendCubit>().getIncomeFriend();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;

          return Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: RefreshIndicator(
                  onRefresh:
                      () => context.read<FriendCubit>().getIncomeFriend(),
                  child:
                      isDesktop
                          ? Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: _buildContent(context),
                            ),
                          )
                          : _buildContent(context),
                ),
              ),
              const AppBarWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SkeletonTheme(
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
                        S.of(context).no_friend_requests,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
            myFriendRequest:
                (friendRequest) => Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Wrap(
                      runSpacing: 16,
                      children: List.generate(friendRequest.length, (index) {
                        final request = friendRequest[index];
                        return FriendRequestCard(friendRequest: request);
                      }),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}
