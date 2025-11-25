import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/friend_dto/friend_dto.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key, required this.friend, required this.theme});
  final FriendDto friend;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO:Навигация к профилю друга
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(friend.avatar),
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    child: null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    friend.username,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (friend.firstname != '' || friend.subname != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${friend.firstname} ${friend.subname}',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      //TODO: Начать чат
                    },
                    tooltip: S.of(context).sendMessage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_remove_outlined),
                    onPressed: () {
                      //TODO: Удалить из друзей
                    },
                    tooltip: S.of(context).removeFriend,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
