import 'package:flutter/material.dart';
import 'package:meet_now_app/features/friends/widget/friend_card.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/friend_dto/friend_dto.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key, required this.friends, required this.theme});
  final List<FriendDto> friends;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return FriendCard(friend: friends[index], theme: theme);
              },
            ),
          ),
        ],
      ),
    );
  }
}
