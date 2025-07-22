import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;

  const MultiSelectDialog({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                widget.items.map((item) {
                  final isSelected = _tempSelected.contains(item);
                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(item),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _tempSelected.add(item);
                        } else {
                          _tempSelected.remove(item);
                        }
                      });
                    },
                  );
                }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _tempSelected),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
