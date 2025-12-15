import 'package:flutter/material.dart';
import 'package:meet_now_app_server/model/notification/user_token_status_dto/user_token_status_dto.dart';
import 'package:meet_now_app_server/model/notification/user_with_token_dto/user_with_token_dto.dart';

class UsersWithTokensCard extends StatelessWidget {
  final List<UserWithTokenDto> users;
  final List<UserWithTokenDto>? onlineUsers;
  final UserTokenStatusDto? selectedUserStatus;
  final VoidCallback onLoadOnlineUsers;
  final ValueChanged<String> onUserTokenStatus;

  const UsersWithTokensCard({
    super.key,
    required this.users,
    this.onlineUsers,
    this.selectedUserStatus,
    required this.onLoadOnlineUsers,
    required this.onUserTokenStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Users with Push Tokens',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.wifi),
                  onPressed: onLoadOnlineUsers,
                  tooltip: 'Load online users',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Статус выбранного пользователя
            if (selectedUserStatus != null) _buildUserStatusCard(),

            // Список пользователей
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildUserItem(user);
                },
              ),
            ),

            // Статистика онлайн пользователей
            if (onlineUsers != null && onlineUsers!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Online Users with Tokens (${onlineUsers!.length})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: onlineUsers!.map((user) {
                      return Chip(
                        label: Text(user.username),
                        avatar: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 10,
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.green[50],
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStatusCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: selectedUserStatus!.isOnline
                ? Colors.green
                : Colors.grey,
            radius: 20,
            child: Text(
              selectedUserStatus!.username.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedUserStatus!.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  selectedUserStatus!.email,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        selectedUserStatus!.hasPushToken
                            ? 'Has Token'
                            : 'No Token',
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: selectedUserStatus!.hasPushToken
                          ? Colors.green[100]
                          : Colors.red[100],
                    ),
                    Chip(
                      label: Text(
                        selectedUserStatus!.isOnline ? 'Online' : 'Offline',
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: selectedUserStatus!.isOnline
                          ? Colors.blue[100]
                          : Colors.grey[100],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(UserWithTokenDto user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: user.isOnline ? Colors.green : Colors.grey,
        child: Text(
          user.username.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(user.username),
      subtitle: Text(
        user.email,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Wrap(
        spacing: 4,
        children: [
          Icon(
            user.hasPushToken
                ? Icons.notifications_active
                : Icons.notifications_off,
            color: user.hasPushToken ? Colors.green : Colors.grey,
            size: 20,
          ),
          Icon(
            Icons.circle,
            color: user.isOnline ? Colors.green : Colors.grey,
            size: 12,
          ),
        ],
      ),
      onTap: () => onUserTokenStatus(user.userId),
    );
  }
}
