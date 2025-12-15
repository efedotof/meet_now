import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/push_notifications/cubit/push_notifications_cubit.dart';
import 'package:meet_now_app_server/model/notification/user_with_token_dto/user_with_token_dto.dart';

class ComposeNotificationCard extends StatefulWidget {
  final NotificationCompose composeData;
  final List<UserWithTokenDto> users;
  final bool isSending;
  final VoidCallback onSend;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onMessageChanged;
  final ValueChanged<NotificationTarget> onTargetChanged;
  final ValueChanged<String?> onTargetUserIdChanged;
  final ValueChanged<String?> onTargetTokenChanged;
  final ValueChanged<NotificationPriority> onPriorityChanged;
  final ValueChanged<String> onDeepLinkChanged;

  const ComposeNotificationCard({
    super.key,
    required this.composeData,
    required this.users,
    required this.isSending,
    required this.onSend,
    required this.onTitleChanged,
    required this.onMessageChanged,
    required this.onTargetChanged,
    required this.onTargetUserIdChanged,
    required this.onTargetTokenChanged,
    required this.onPriorityChanged,
    required this.onDeepLinkChanged,
  });

  @override
  State<ComposeNotificationCard> createState() =>
      _ComposeNotificationCardState();
}

class _ComposeNotificationCardState extends State<ComposeNotificationCard> {
  late TextEditingController _titleController;
  late TextEditingController _messageController;
  late TextEditingController _deepLinkController;
  late TextEditingController _tokenController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.composeData.title);
    _messageController = TextEditingController(
      text: widget.composeData.message,
    );
    _deepLinkController = TextEditingController(
      text: widget.composeData.deepLink ?? '',
    );
    _tokenController = TextEditingController(
      text: widget.composeData.targetPushToken ?? '',
    );
  }

  @override
  void didUpdateWidget(ComposeNotificationCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Обновляем контроллеры только если значения изменились извне
    if (widget.composeData.title != _titleController.text) {
      _titleController.text = widget.composeData.title;
    }

    if (widget.composeData.message != _messageController.text) {
      _messageController.text = widget.composeData.message;
    }

    if ((widget.composeData.deepLink ?? '') != _deepLinkController.text) {
      _deepLinkController.text = widget.composeData.deepLink ?? '';
    }

    if ((widget.composeData.targetPushToken ?? '') != _tokenController.text) {
      _tokenController.text = widget.composeData.targetPushToken ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _deepLinkController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

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
                  'Compose Notification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                if (widget.composeData.scheduledTime != null)
                  Chip(
                    label: Text(
                      'Scheduled: ${widget.composeData.scheduledTime!.toString()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.orange[50],
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Target Selection
            _buildTargetSelector(),
            const SizedBox(height: 16),

            // User/Token Selection (if needed)
            if (widget.composeData.target == NotificationTarget.specificUser)
              _buildUserSelector(),
            if (widget.composeData.target == NotificationTarget.specificToken ||
                widget.composeData.target ==
                    NotificationTarget.dataNotification)
              _buildTokenInput(),

            // Title
            _buildTitleField(),
            const SizedBox(height: 16),

            // Message
            _buildMessageField(),
            const SizedBox(height: 16),

            // Priority
            _buildPrioritySelector(),
            const SizedBox(height: 16),

            // Deep Link
            _buildDeepLinkField(),
            const SizedBox(height: 20),

            // Send Button
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetSelector() {
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
            _buildTargetChip('All Users', NotificationTarget.allUsers),
            _buildTargetChip('Specific User', NotificationTarget.specificUser),
            _buildTargetChip(
              'Specific Token',
              NotificationTarget.specificToken,
            ),
            _buildTargetChip(
              'Data Notification',
              NotificationTarget.dataNotification,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTargetChip(String label, NotificationTarget target) {
    final isSelected = widget.composeData.target == target;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          widget.onTargetChanged(target);
        }
      },
      selectedColor: Colors.blue[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[700] : Colors.grey[700],
      ),
    );
  }

  Widget _buildUserSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select User',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: widget.composeData.targetUserId,
          items: widget.users.map((user) {
            return DropdownMenuItem(
              value: user.userId,
              child: Text('${user.username} (${user.email})'),
            );
          }).toList(),
          onChanged: widget.onTargetUserIdChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Select a user',
          ),
        ),
      ],
    );
  }

  Widget _buildTokenInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Push Token',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _tokenController,
          onChanged: widget.onTargetTokenChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Enter push token',
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      onChanged: widget.onTitleChanged,
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

  Widget _buildMessageField() {
    return TextField(
      controller: _messageController,
      onChanged: widget.onMessageChanged,
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

  Widget _buildPrioritySelector() {
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
            _buildPriorityChip('Low', NotificationPriority.low, Colors.green),
            _buildPriorityChip(
              'Normal',
              NotificationPriority.normal,
              Colors.blue,
            ),
            _buildPriorityChip(
              'High',
              NotificationPriority.high,
              Colors.orange,
            ),
            _buildPriorityChip(
              'Urgent',
              NotificationPriority.urgent,
              Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(
    String label,
    NotificationPriority priority,
    Color color,
  ) {
    final isSelected = widget.composeData.priority == priority;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          widget.onPriorityChanged(priority);
        }
      },
      selectedColor: color.withAlpha(20),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDeepLinkField() {
    return TextField(
      controller: _deepLinkController,
      onChanged: widget.onDeepLinkChanged,
      decoration: InputDecoration(
        labelText: 'Deep Link (optional)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final isValid =
        widget.composeData.title.isNotEmpty &&
        widget.composeData.message.isNotEmpty &&
        (widget.composeData.target != NotificationTarget.specificUser ||
            widget.composeData.targetUserId != null) &&
        (widget.composeData.target != NotificationTarget.specificToken ||
            widget.composeData.targetPushToken != null);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isValid && !widget.isSending ? widget.onSend : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: widget.isSending
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
  }
}
