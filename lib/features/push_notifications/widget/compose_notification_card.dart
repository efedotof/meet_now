import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';

class ComposeNotificationCard extends StatelessWidget {
  final NotificationCompose composeData;

  const ComposeNotificationCard({super.key, required this.composeData});

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
            Text(
              'Compose Notification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            _buildTitleField(context),
            const SizedBox(height: 16),
            _buildMessageField(context),
            const SizedBox(height: 16),
            _buildTargetSelector(context),
            const SizedBox(height: 16),
            _buildPrioritySelector(context),
            const SizedBox(height: 20),
            _buildSendButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextField(
      onChanged: (value) =>
          context.read<PushNotificationsCubit>().updateComposeTitle(value),
      decoration: InputDecoration(
        labelText: 'Notification Title',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      maxLength: 60,
    );
  }

  Widget _buildMessageField(BuildContext context) {
    return TextField(
      onChanged: (value) =>
          context.read<PushNotificationsCubit>().updateComposeMessage(value),
      decoration: InputDecoration(
        labelText: 'Notification Message',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      maxLines: 3,
      maxLength: 240,
    );
  }

  Widget _buildTargetSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Audience',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTargetChip(context, 'All Users', NotificationTarget.allUsers),
            _buildTargetChip(
              context,
              'Active Users',
              NotificationTarget.activeUsers,
            ),
            _buildTargetChip(
              context,
              'Premium Users',
              NotificationTarget.premiumUsers,
            ),
            _buildTargetChip(context, 'New Users', NotificationTarget.newUsers),
          ],
        ),
      ],
    );
  }

  Widget _buildTargetChip(
    BuildContext context,
    String label,
    NotificationTarget target,
  ) {
    final isSelected = composeData.target == target;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<PushNotificationsCubit>().updateComposeTarget(target);
        }
      },
      selectedColor: Colors.blue[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[700] : Colors.grey[700],
      ),
    );
  }

  Widget _buildPrioritySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPriorityChip(context, 'Low', NotificationPriority.low),
            _buildPriorityChip(context, 'Normal', NotificationPriority.normal),
            _buildPriorityChip(context, 'High', NotificationPriority.high),
            _buildPriorityChip(context, 'Urgent', NotificationPriority.urgent),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(
    BuildContext context,
    String label,
    NotificationPriority priority,
  ) {
    final isSelected = composeData.priority == priority;
    Color color;
    switch (priority) {
      case NotificationPriority.low:
        color = Colors.green;
        break;
      case NotificationPriority.normal:
        color = Colors.blue;
        break;
      case NotificationPriority.high:
        color = Colors.orange;
        break;
      case NotificationPriority.urgent:
        color = Colors.red;
        break;
    }

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<PushNotificationsCubit>().updateComposePriority(
            priority,
          );
        }
      },
      selectedColor: color.withAlpha(2),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return BlocBuilder<PushNotificationsCubit, PushNotificationsState>(
      builder: (context, state) {
        final isValid =
            composeData.title.isNotEmpty && composeData.message.isNotEmpty;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isValid && !state.isSending
                ? () =>
                      context.read<PushNotificationsCubit>().sendNotification()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isSending
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Send Notification',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }
}
