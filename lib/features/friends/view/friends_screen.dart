import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';
import 'package:meet_now_app/features/friends/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

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
    context.read<FriendsCubit>().getFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).friends)),
      body: RefreshIndicator(
        onRefresh: () => context.read<FriendsCubit>().refreshFriend(),
        child: BlocBuilder<FriendsCubit, FriendsState>(
          builder: (context, state) {
            return state.when(
              initial:
                  () => Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
              friendsList: (friends) {
                if (friends.isEmpty) {
                  return EmptyState(theme: theme);
                }
                return FriendsList(friends: friends, theme: theme);
              },
            );
          },
        ),
      ),
    );
  }
}
