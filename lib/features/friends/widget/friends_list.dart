import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/friends/cubit/friends_cubit.dart';
import 'package:meet_now_app/features/friends/widget/friend_card.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/friend_dto/friend_dto.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key, required this.friends});
  final List<FriendDto> friends;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        return RefreshIndicator(
          onRefresh: () => context.read<FriendsCubit>().getFriendsList(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: S.of(context).searchFriendsHint,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  children: List.generate(
                    friends.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FriendCard(friend: friends[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
