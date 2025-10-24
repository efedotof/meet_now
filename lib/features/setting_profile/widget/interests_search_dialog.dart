import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app_server/model/interes/interest.dart';
import 'package:meet_now_app_server/storage/hive/repository/storage_hive_interface.dart';

class InterestsSearchDialog extends StatefulWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onInterestsUpdated;

  const InterestsSearchDialog({
    super.key,
    required this.selectedInterests,
    required this.onInterestsUpdated,
  });

  @override
  State<InterestsSearchDialog> createState() => _InterestsSearchDialogState();
}

class _InterestsSearchDialogState extends State<InterestsSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _tempSelectedInterests = [];
  late List<Interest> _allInterests = [];
  List<Interest> _filteredInterests = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedInterests.addAll(widget.selectedInterests);
    _searchController.addListener(_filterInterests);
  }

  void _filterInterests() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInterests =
          _allInterests.where((interest) {
            final title = interest.title?.toLowerCase() ?? '';
            return title.contains(query);
          }).toList();
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_tempSelectedInterests.contains(interest)) {
        _tempSelectedInterests.remove(interest);
      } else {
        _tempSelectedInterests.add(interest);
      }
    });
  }

  void _applySelection() {
    widget.onInterestsUpdated(_tempSelectedInterests);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Выберите интересы',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Поиск интересов...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<Box>(
                valueListenable:
                    context.read<StorageHiveInterface>().listenableInterestBox,
                builder: (context, box, child) {
                  _allInterests = box.values.cast<Interest>().toList();
                  if (_filteredInterests.isEmpty) {
                    _filteredInterests = _allInterests;
                  }

                  return ListView.builder(
                    itemCount: _filteredInterests.length,
                    itemBuilder: (context, index) {
                      final interest = _filteredInterests[index];
                      final isSelected = _tempSelectedInterests.contains(
                        interest.title,
                      );

                      return CheckboxListTile(
                        title: Text(interest.title ?? ''),
                        value: isSelected,
                        onChanged: (_) => _toggleInterest(interest.title!),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applySelection,
                    child: const Text('Применить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
