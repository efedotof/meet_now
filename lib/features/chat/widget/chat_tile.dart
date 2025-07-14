import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final int unreadCount;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: theme.cardTheme.shape,
      color: theme.cardTheme.color,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.secondary,
          child: Icon(Icons.person, color: theme.iconTheme.color),
        ),
        title: Text(name, style: theme.textTheme.titleLarge),
        subtitle: Text(
          lastMessage,
          style: theme.textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing:
            unreadCount > 0
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$unreadCount',
                    style: TextStyle(
                      color:
                          theme.colorScheme.brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
                : null,
        onTap: () {},
      ),
    );
  }
}
