// block_user_dialog.dart
import 'package:flutter/material.dart';

class BlockUserDialog extends StatefulWidget {
  final String username;
  final String? initialReason;
  final Function(String) onBlock;

  const BlockUserDialog({
    super.key,
    required this.username,
    this.initialReason,
    required this.onBlock,
  });

  @override
  State<BlockUserDialog> createState() => _BlockUserDialogState();
}

class _BlockUserDialogState extends State<BlockUserDialog> {
  late TextEditingController _reasonController;
  final FocusNode _reasonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(text: widget.initialReason ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _reasonFocusNode.requestFocus();
        // Если есть начальный текст, перемещаем курсор в конец
        if (widget.initialReason != null && widget.initialReason!.isNotEmpty) {
          _reasonController.selection = TextSelection.fromPosition(
            TextPosition(offset: _reasonController.text.length),
          );
        }
      }
    });
  }

  @override
  void didUpdateWidget(BlockUserDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Обновляем текст контроллера, если initialReason изменился
    if (widget.initialReason != oldWidget.initialReason) {
      _reasonController.text = widget.initialReason ?? '';
      // Обновляем позицию курсора
      _reasonController.selection = TextSelection.fromPosition(
        TextPosition(offset: _reasonController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _reasonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Block ${widget.username}',
        style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please provide a reason for blocking this user:',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            focusNode: _reasonFocusNode,
            maxLines: 3,
            onChanged: (_) {
              // Принудительно перестраиваем виджет при изменении текста
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Enter reason...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This reason will be visible to the user and other administrators.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          onPressed: _reasonController.text.trim().isEmpty
              ? null
              : () {
                  widget.onBlock(_reasonController.text.trim());
                  Navigator.pop(context);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Block User'),
        ),
      ],
    );
  }
}
