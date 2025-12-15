import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/users/cubit/users_cubit.dart';
import 'package:meet_now_admin_panel/features/users/widget/user_ui_models.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildRoleBadges(),
                      _buildVerificationBadge(),
                      if (user.city != null) _buildCityBadge(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActivityInfo(),
                      const Spacer(),
                      _buildActionButtons(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: _getUserColor(), shape: BoxShape.circle),
      child: Center(
        child: Text(
          user.username[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isOnline = user.isOnline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green[50]! : Colors.grey[200]!,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 10,
              color: isOnline ? Colors.green[700]! : Colors.grey[700]!,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadges() {
    final roles = user.roles.toList();

    if (roles.isEmpty) {
      return Container();
    }

    return Wrap(
      spacing: 4,
      children: roles.map((role) {
        Color backgroundColor;
        Color textColor;
        String displayText;

        switch (role) {
          case 'premium':
            backgroundColor = Colors.purple[50]!;
            textColor = Colors.purple[700]!;
            displayText = 'Premium';
            break;
          case 'admin':
            backgroundColor = Colors.red[50]!;
            textColor = Colors.red[700]!;
            displayText = 'Admin';
            break;
          case 'moderator':
            backgroundColor = Colors.green[50]!;
            textColor = Colors.green[700]!;
            displayText = 'Moderator';
            break;
          default:
            backgroundColor = Colors.blue[50]!;
            textColor = Colors.blue[700]!;
            displayText = 'User';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            displayText,
            style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: user.verified ? Colors.green[50]! : Colors.orange[50]!,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            user.verified ? Icons.verified : Icons.warning,
            size: 12,
            color: user.verified ? Colors.green[700]! : Colors.orange[700]!,
          ),
          const SizedBox(width: 2),
          Text(
            user.verified ? 'Verified' : 'Unverified',
            style: TextStyle(
              fontSize: 10,
              color: user.verified ? Colors.green[700]! : Colors.orange[700]!,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100]!,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 12, color: Colors.grey[600]!),
          const SizedBox(width: 2),
          Text(
            user.city!,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700]!,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${user.friends?.length ?? 0} friends',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          '${user.gamePoints} points',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          _formatDate(user.createdAt),
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (!user.isModerator) ...[
          ElevatedButton(
            onPressed: () =>
                context.read<UsersCubit>().upgradeToPremium(user.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[50],
              foregroundColor: Colors.purple[700],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.purple[100]!),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Text('Upgrade to Premium'),
          ),
          const SizedBox(width: 8),
        ],
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          onPressed: () {
            _showMoreOptions(context);
          },
        ),
      ],
    );
  }

  Color _getUserColor() {
    if (user.isPremium) return Colors.purple;
    if (user.isAdmin) return Colors.red;
    if (user.isModerator) return Colors.green;
    return Colors.blue;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) return 'Today';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    if (difference.inDays < 30) return '${difference.inDays ~/ 7}w ago';
    return '${difference.inDays ~/ 30}mo ago';
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit User'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Send Message'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement send message
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.orange),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<UsersCubit>().blockUser(user.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete User',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<UsersCubit>().deleteUser(user.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
