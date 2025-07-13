import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';

@RoutePage()
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friends")),
      body: BlocBuilder<FriendsCubit, FriendsState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(child: CircularProgressIndicator()),
            friendsList:
                (friends) => SingleChildScrollView(
                  child: Wrap(
                    children: List.generate(
                      friends.length,
                      (index) => SizedBox(
                        child: Column(
                          children: [Text(friends[index].username)],
                        ),
                      ),
                    ),
                  ),
                ),
          );
        },
      ),
    );
  }
}
