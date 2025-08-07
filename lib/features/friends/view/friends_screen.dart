import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';
import 'package:meet_now_app/features/friends/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).friends)),
      body: BlocBuilder<FriendsCubit, FriendsState>(
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
    );
  }
}
